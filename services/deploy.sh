#!/bin/bash
set -eu

terraform apply

PLAYBOOK_DIR=../../setup_server ./provision_services
