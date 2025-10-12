{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.encrypted-dns;
in
{
  options.jpcenteno.nixos.system.encrypted-dns = {
    enable = lib.mkEnableOption "Encrypted DNS proxy";
  };

  config = lib.mkIf cfg.enable {
    services.dnscrypt-proxy2 = {
      enable = lib.mkForce true;

      # The service will source the configuration file directly from the Nix
      # store. You can check which file is being used by running
      # `systemctl status dnscrypt-proxy2.service` and inspecting the command
      # line flags.
      settings = {
        # Resolver selection:
        dnscrypt_servers = false;
        doh_servers = true;

        # Filters the resolvers declared by remote sources, ignoring those who
        # don't support DNSSEC. This protects the integrity of responses.
        require_dnssec = true;

        # Filters the resolvers declared by remote sources, keeping those that
        # PROMISE (You never know for sure) not to log your requests.
        require_nolog = true;

        # Filters the resolvers declared by remote sources removing those who
        # perform some kind of filtering (Ads, social media, adult sites, etc).
        # While this forces you to maintain your own blocklist, it reduces the
        # scope of where to look when debugging DNS issues.
        require_nofilter = true;

        # This is an extensive list of public DNS resolvers supporting DNSCrypt
        # and DoH. It is maintained by the folks at `dnscrypt.info`.
        #
        # You can then specify which ones to use by setting `server_names` or
        # filter them with the `require_*` options. Note that `dnscrypt-proxy`
        # will ignore the `require_*` filters if `server_names` is set.
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          cache_file = "public-resolvers.md";
        };
      };
    };
  };
}
