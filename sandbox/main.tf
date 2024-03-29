provider "digitalocean" {
    token  = var.do_token
}

data "digitalocean_droplet_snapshot" "sandbox" {
    name_regex = "sandbox-\\d*"
    region = var.region
    most_recent = true
}

resource "digitalocean_droplet" "sandbox" {
    name               = "sandbox"
    image              = data.digitalocean_droplet_snapshot.sandbox.id
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags               = [
        "sandbox",
        "logging",
        "jenkins",
        "zookeeper",
        "Kafka",
    ]
}

resource "digitalocean_firewall" "sandbox" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "sandbox"

    tags = [
        "sandbox"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
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

resource "digitalocean_firewall" "logging" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "logging"

    tags = [
        "logging"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_tags = ["sandbox"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "514"
        source_tags      = ["website"]
    }

    inbound_rule {
        protocol         = "udp"
        port_range       = "514"
        source_tags      = ["website"]
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
resource "digitalocean_firewall" "jenkins" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "jenkins"

    tags = [
        "jenkins"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_tags = ["sandbox"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "80"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "443"
        source_addresses = ["0.0.0.0/0", "::/0"]
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

resource "digitalocean_firewall" "Kafka" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "Kafka"

    tags = [
        "Kafka"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_tags = ["sandbox"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "9092"
        source_tags           = ["website"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "9092"
        source_tags           = ["consumer"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "9092"
        source_tags           = ["Kafka"]
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

resource "digitalocean_firewall" "zookeeper" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "zookeeper"

    tags = [
        "zookeeper"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_tags = ["sandbox"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "2181"
        source_tags           = ["website"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "2181"
        source_tags           = ["consumer"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "2181"
        source_tags           = ["Kafka"]
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

output "ips" {
    value = digitalocean_droplet.sandbox[*].ipv4_address
}
