# vim: sts=4 ts=4 sw=4 expandtab autoindent
#
#INSTALL SKYPE ON DESKTOP
#
class puppet-skype-desktop ($source, $destination = "/root/skype.deb") {
    #support multiarch
    if defined (Exec["i386"]) {
        exec{ "i386":
            command => "dpkg --add-architecture i386;apt-get update;",
            path => '/usr/bin:/bin:/usr/sbin:/sbin',
            unless => '/usr/bin/dpkg --print-foreign-architectures | /bin/grep i386'
        }
    }

    wget::fetch { 'skype.deb':
        source      => $source,
        destination => $destination,
        timeout     => 0,
        verbose     => false,
    }

    package {"skype":
        provider => dpkg,
        ensure   => latest,
        source   => $destination,
        require  => Wget::Fetch['skype.deb']
    }
}
