import argparse
import logging
from visdom import server 

print(dir(server))

DEFAULT_USERNAME = ""
DEFAULT_PASSWORD = ""

def main(print_func=None):
    parser = argparse.ArgumentParser(description='Start the visdom server.')
    parser.add_argument('--port', metavar='port', type=int,
                        default=server.DEFAULT_PORT,
                        help='port to run the server on.')
    parser.add_argument('--hostname', metavar='hostname', type=str,
                        default=server.DEFAULT_HOSTNAME,
                        help='host to run the server on.')
    parser.add_argument('--base_url', metavar='base_url', type=str,
                        default=server.DEFAULT_BASE_URL,
                        help='base url for server (default = /).')
    parser.add_argument('--env_path', metavar='env_path', type=str,
                        default=server.DEFAULT_ENV_PATH,
                        help='path to serialized session to reload.')
    parser.add_argument('--username', metavar='username', type=str,
                        default=DEFAULT_USERNAME,
                        help='username for login.')
    parser.add_argument('--password', metavar='password', type=str,
                        default=DEFAULT_PASSWORD,
                        help='password for login.')
    parser.add_argument('--logging_level', metavar='logger_level',
                        default='INFO',
                        help='logging level (default = INFO). Can take '
                             'logging level name or int (example: 20)')
    parser.add_argument('--readonly', help='start in readonly mode',
                        action='store_true')
    parser.add_argument('--enable_login', default=False, action='store_true',
                        help='start the server with authentication')
    parser.add_argument('--force_new_cookie', default=False,
                        action='store_true',
                        help='start the server with the new cookie, '
                             'available when -enable_login provided')
    FLAGS = parser.parse_args()

    # Process base_url
    base_url = FLAGS.base_url if FLAGS.base_url != DEFAULT_BASE_URL else ""
    assert base_url == '' or base_url.startswith('/'), \
        'base_url should start with /'
    assert base_url == '' or not base_url.endswith('/'), \
        'base_url should not end with / as it is appended automatically'

    try:
        logging_level = int(FLAGS.logging_level)
    except (ValueError,):
        try:
            logging_level = logging._checkLevel(FLAGS.logging_level)
        except ValueError:
            raise KeyError(
                "Invalid logging level : {0}".format(FLAGS.logging_level)
            )

    logging.getLogger().setLevel(logging_level)

    if FLAGS.enable_login:
        user_credential = {
            "username": username,
            "password": hash_password(hash_password(password))
        }

        if not os.path.isfile(DEFAULT_ENV_PATH + "COOKIE_SECRET"):
            set_cookie()
        elif FLAGS.force_new_cookie:
            set_cookie()
    else:
        user_credential = None

    start_server(port=FLAGS.port, hostname=FLAGS.hostname, base_url=base_url,
                 env_path=FLAGS.env_path, readonly=FLAGS.readonly,
                 print_func=print_func, user_credential=user_credential)

def download_scripts_and_run():
    server.download_scripts()
    main()

if __name__ == "__main__":
    download_scripts_and_run()

