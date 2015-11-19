  # have to find a better way to do this, if we can execute plugin before upload_cirros task we don't need this anymore
  exec{ "image-delete":
  command       => "/bin/bash -c 'source /root/openrc && /usr/bin/glance image-delete TestVM'",
  }