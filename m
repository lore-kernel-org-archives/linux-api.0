From: Richard Weinberger <richard@nod.at>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Thu, 28 May 2015 22:30:39 +0200
Message-ID: <55677AEF.1090809@nod.at>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>	<87siaxuvik.fsf@x220.int.ebiederm.org>	<87wq004im1.fsf@x220.int.ebiederm.org>	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>	<20150528140839.GD28842@ubuntumail> <55676E32.3050006@nod.at> <87382gh3uo.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87382gh3uo.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Am 28.05.2015 um 21:57 schrieb Eric W. Biederman:
>> FWIW, it breaks also libvirt-lxc:
>> Error: internal error: guest failed to start: Failed to re-mount /proc/sys on /proc/sys flags=1021: Operation not permitted
> 
> Interesting.  I had not anticipated a failure there?  And it is failing
> in remount?  Oh that is interesting.
> 
> That implies that there is some flag of the original mount of /proc that
> the remount of /proc/sys is clearing, and that previously 
> 
> The flags specified are current rdonly,remount,bind so I expect there
> are some other flags on proc that libvirt-lxc is clearing by accident
> and we did not fail before because the kernel was not enforcing things.

Please see:
http://libvirt.org/git/?p=libvirt.git;a=blob;f=src/lxc/lxc_container.c;h=9a9ae5c2aaf0f90ff472f24fda43c077b44998c7;hb=HEAD#l933
lxcContainerMountBasicFS()

and:
http://libvirt.org/git/?p=libvirt.git;a=blob;f=src/lxc/lxc_container.c;h=9a9ae5c2aaf0f90ff472f24fda43c077b44998c7;hb=HEAD#l850
lxcBasicMounts

> What are the mount flags in a working libvirt-lxc?

See:
test1:~ # cat /proc/self/mountinfo
147 100 0:30 /srv/container/test1/rootfs / rw,relatime - btrfs /dev/sda2 rw,space_cache
149 147 0:56 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
150 149 0:56 /sys /proc/sys ro,nodev,relatime - proc proc rw
151 150 0:3 /sys/net/ipv4 /proc/sys/net/ipv4 rw,nosuid,nodev,noexec,relatime - proc proc rw
152 150 0:3 /sys/net/ipv6 /proc/sys/net/ipv6 rw,nosuid,nodev,noexec,relatime - proc proc rw
153 147 0:57 / /sys ro,nodev,relatime - sysfs sysfs rw
154 149 0:53 /meminfo /proc/meminfo rw,nosuid,nodev,relatime - fuse libvirt rw,user_id=0,group_id=0,allow_other
155 153 0:58 / /sys/fs/cgroup rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs rw,size=64k,mode=755,uid=10000,gid=10000
156 155 0:22 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
157 155 0:21 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset
158 155 0:23 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
159 155 0:24 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
160 155 0:25 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
161 155 0:27 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
162 155 0:26 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
163 155 0:28 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
164 155 0:19 /machine.slice/machine-lxc\134x2dtest1.scope /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup
rw,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
165 147 0:52 / /dev rw,nosuid,relatime - tmpfs devfs rw,size=64k,mode=755
166 165 0:51 / /dev/pts rw,nosuid,relatime - devpts devpts rw,gid=10005,mode=620,ptmxmode=666
167 165 0:51 /ptmx /dev/ptmx rw,nosuid,relatime - devpts devpts rw,gid=10005,mode=620,ptmxmode=666
101 165 0:55 / /dev/shm rw,nosuid,nodev - tmpfs tmpfs rw,uid=10000,gid=10000
102 147 0:59 / /run rw,nosuid,nodev - tmpfs tmpfs rw,mode=755,uid=10000,gid=10000
103 165 0:54 / /dev/mqueue rw,nodev,relatime - mqueue mqueue rw
104 147 0:59 / /var/run rw,nosuid,nodev - tmpfs tmpfs rw,mode=755,uid=10000,gid=10000
105 147 0:59 /lock /var/lock rw,nosuid,nodev - tmpfs tmpfs rw,mode=755,uid=10000,gid=10000

If you need more info, please let me know. :-)

Thanks,
//richard
