resource "tls_private_key" "key_tls" {
  count     = var.public_ssh_key_path != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}