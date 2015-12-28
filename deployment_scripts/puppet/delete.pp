  # have to find a better way to do this, if we can execute plugin before upload_cirros task we don't need this anymore
      glance_image { "TestVM":
        ensure          => 'absent',
        name            => "TestVM",
      }
      glance_image { "TestVM-VMDK":
        ensure          => 'absent',
        name            => "TestVM-VMDK",
      }