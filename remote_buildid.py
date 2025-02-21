from steam.client import SteamClient


def main():
    client = SteamClient()
    client.anonymous_login()

    app_id = 232250
    infos = client.get_product_info([app_id])['apps']
    print(infos[app_id]['depots']['branches']['public']['buildid'])


if __name__ == "__main__":
    main()