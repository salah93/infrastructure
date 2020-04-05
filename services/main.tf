provider "digitalocean" {
    token  = var.do_token
}

data "digitalocean_droplet_snapshot" "services" {
    name_regex = "sandbox-\\d*"
    region = var.region
    most_recent = true
}

resource "digitalocean_droplet" "services" {
    name               = "services"
    image              = data.digitalocean_droplet_snapshot.services.id
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags               = [
        "websocket",
        "mongodb",
        "consumer",
        "services",
    ]
}

resource "digitalocean_firewall" "services" {
    depends_on = [digitalocean_droplet.services]
    name = "services"

    tags = [
        "services"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_tags = ["sandbox"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = [var.access_ip]
    }

    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol              = "udp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}

resource "digitalocean_firewall" "websocket" {
    depends_on = [digitalocean_droplet.services]
    name = "websocket"

    tags = [
        "websocket"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "5678"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }
}

output "ips" {
    value = digitalocean_droplet.services[*].ipv4_address
}
