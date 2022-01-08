#include <erl_nif.h>
#include <dds/dds.h>
#include "HelloWorldData.h"
#include <string.h>

static dds_entity_t participant;
static dds_entity_t topic;
static dds_entity_t writer;
static dds_entity_t reader;
static dds_qos_t *qos;
static dds_entity_t rc;
static uint32_t status = 0;
static HelloWorldData_Msg msg;
static HelloWorldData_Msg *receivemsg;

#define MAX_SAMPLES 1

ERL_NIF_TERM ddstest_create_publisher(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{

	participant = dds_create_participant(DDS_DOMAIN_DEFAULT, NULL, NULL);

	topic = dds_create_topic(participant, &HelloWorldData_Msg_desc, "HelloWorldData_Msg", NULL, NULL);
	writer = dds_create_writer(participant, topic, NULL, NULL);
	rc = dds_set_status_mask(writer, DDS_PUBLICATION_MATCHED_STATUS);

	enif_fprintf(stdout, "Waiting for dds publication match...\n");

	while (!(status & DDS_PUBLICATION_MATCHED_STATUS))
	{
		rc = dds_get_status_changes(writer, &status);
		if (rc != DDS_RETCODE_OK)
		{
			// printf("dds_get_status_changes: %s\n", dds_strretcode(-rc));
			return enif_make_badarg(env);
		}
		dds_sleepfor(DDS_MSECS(20));
	}

	return enif_make_int(env, 0);
}

ERL_NIF_TERM ddstest_sendmsg(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{

	if (argc != 1)
	{
		return enif_make_badarg(env);
	}
	char buf[128];
	(void)memset(&buf, '\0', sizeof(buf));
	if (!enif_get_string(env, argv[0], buf, sizeof(buf), ERL_NIF_LATIN1))
	{
		return enif_make_badarg(env);
	}
	msg.userID = 1;
	msg.message = buf;

	rc = dds_write(writer, &msg);
	if (rc != DDS_RETCODE_OK)
	{
		return enif_make_badarg(env);
	}
	return enif_make_string(env, buf, ERL_NIF_LATIN1);
}

ERL_NIF_TERM ddstest_delete(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
	rc = dds_delete(participant);
	return enif_make_int(env, 0);
}

ERL_NIF_TERM ddstest_create_subscriber(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
	void *samples[MAX_SAMPLES];
	dds_sample_info_t infos[MAX_SAMPLES];

	participant = dds_create_participant(DDS_DOMAIN_DEFAULT, NULL, NULL);
	topic = dds_create_topic(participant, &HelloWorldData_Msg_desc, "HelloWorldData_Msg", NULL, NULL);
	qos = dds_create_qos();
	dds_qset_reliability(qos, DDS_RELIABILITY_RELIABLE, DDS_SECS(10));
	reader = dds_create_reader(participant, topic, qos, NULL);
	dds_delete_qos(qos);

	enif_fprintf(stdout, "\n=== [Subscriber] Waiting for a sample...\n");

	samples[0] = HelloWorldData_Msg__alloc();

	while (true)
	{
		rc = dds_read(reader, samples, infos, MAX_SAMPLES, MAX_SAMPLES);
		if (rc < 0)
		{
			return enif_make_badarg(env);
		}
		if ((rc > 0) && (infos[0].valid_data))
		{
			receivemsg = (HelloWorldData_Msg *)samples[0];
			enif_fprintf(stdout, "=== [Subscriber] Received : %s\n", receivemsg->message);
			break;
		}
		else
		{
			dds_sleepfor(DDS_MSECS(20));
		}
	}
	HelloWorldData_Msg_free(samples[0], DDS_FREE_ALL);
	return enif_make_int(env, 0);
}

ERL_NIF_TERM ddstest_test(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
	return enif_make_int(env, 1);
}

/*
int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info){

	return 0;
}
*/

static ErlNifFunc nif_funcs[] = {
	{"ddstest_create_publisher", 0, ddstest_create_publisher, 0},
	{"ddstest_create_subscriber", 0, ddstest_create_subscriber, 0},
	{"ddstest_sendmsg", 1, ddstest_sendmsg, 0},
	{"ddstest_delete", 0, ddstest_delete, 0},
	{"ddstest_test", 0, ddstest_test, 0},
};

ERL_NIF_INIT(Elixir.Ddstest, nif_funcs, NULL, NULL, NULL, NULL)
