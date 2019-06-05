From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 10/25] vfs: fsinfo sample: Mount listing program [ver #13]
Date: Wed, 5 Jun 2019 13:22:12 +0100
Message-ID: <9eeb6b39-c4a1-6e3d-246a-e1cf97d84b33@gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905634517.1662.7843563955043166854.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905634517.1662.7843563955043166854.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 28/05/2019 16:12, David Howells wrote:
> Implement a program to demonstrate mount listing using the new fsinfo()
> syscall,

Great. I understand this is only for demonstration, but IMO the output 
would be clearer with a few tweaks:

> for example:
>
> # ./test-mntinfo

Can we have a header please?  E.g.

   MNT                                    ID       NOTIFS   TYPE DEVICE
   -------------------------------------- -------- -------- ---- ------


> ROOT                                          5d        c ext4 8:12
>   \_ sys                                       13        8 sysfs 0:13
>   |   \_ kernel/security                       16        0 securityfs 0:7

I assume ID is the same ID which is shown in /proc/mounts.  But it's 
shown as decimal there.  Can we match that?

And can we show NOTIFS in decimal as well? I find counters easier to 
read in decimal :-).

I.e. change "%8x" to "%10d" in both cases.

major:minor is also more often seen formatted as "%d:%d": in 
/proc/self/mountinfo, lsblk, and ls -l.  I don't feel as strongly about 
this one though.

Thanks
Alan

>   |   \_ fs/cgroup                             1a       10 tmpfs 0:17
>   |   |   \_ unified                           1b        0 cgroup2 0:18
>   |   |   \_ systemd                           1c        0 cgroup 0:19
>   |   |   \_ freezer                           20        0 cgroup 0:1d
>   |   |   \_ cpu,cpuacct                       21        0 cgroup 0:1e
>   |   |   \_ memory                            22        0 cgroup 0:1f
>   |   |   \_ cpuset                            23        0 cgroup 0:20
>   |   |   \_ hugetlb                           24        0 cgroup 0:21
>   |   |   \_ net_cls,net_prio                  25        0 cgroup 0:22
>   |   |   \_ blkio                             26        0 cgroup 0:23
>   |   |   \_ perf_event                        27        0 cgroup 0:24
>   |   |   \_ devices                           28        0 cgroup 0:25
>   |   |   \_ rdma                              29        0 cgroup 0:26
>   |   \_ fs/pstore                             1d        0 pstore 0:1a
>   |   \_ firmware/efi/efivars                  1e        0 efivarfs 0:1b
>   |   \_ fs/bpf                                1f        0 bpf 0:1c
>   |   \_ kernel/config                         5a        0 configfs 0:10
>   |   \_ fs/selinux                            2a        0 selinuxfs 0:12
>   |   \_ kernel/debug                          2e        0 debugfs 0:8
>   \_ dev                                       15        4 devtmpfs 0:6
>   |   \_ shm                                   17        0 tmpfs 0:14
>   |   \_ pts                                   18        0 devpts 0:15
>   |   \_ hugepages                             2b        0 hugetlbfs 0:27
>   |   \_ mqueue                                2c        0 mqueue 0:11
>   \_ run                                       19        1 tmpfs 0:16
>   |   \_ user/0                               1b4        0 tmpfs 0:2d
>   \_ proc                                      14        1 proc 0:4
>   |   \_ sys/fs/binfmt_misc                    2d        0 autofs 0:28
>   \_ tmp                                       2f      7d0 tmpfs 0:29
>   \_ var/cache/fscache                         71        0 tmpfs 0:2a
>   \_ boot                                      74        0 ext4 8:15
>   \_ home                                      74        0 ext4 8:15
>   \_ var/lib/nfs/rpc_pipefs                    bf        0 rpc_pipefs 0:2b
>   \_ mnt                                      15b        5 tmpfs 0:2c
>   |   \_ foo                                  164        0 tmpfs 0:2e
>   |   \_ foo1                                 16d        0 tmpfs 0:2f
>   |   \_ foo2                                 176        0 tmpfs 0:30
>   |   \_ foo3                                 17f        0 tmpfs 0:31
>   |   \_ foo4                                 188        1 tmpfs 0:32
>   |       \_ ""                               191        0 tmpfs 0:33
>   \_ afs                                      19a        2 afs 0:34
>       \_ procyon.org.uk                       1a3        0 afs 0:35
>       \_ grand.central.org                    1ac        0 afs 0:36
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   samples/vfs/Makefile       |    3 +
>   samples/vfs/test-mntinfo.c |  239 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 242 insertions(+)
>   create mode 100644 samples/vfs/test-mntinfo.c

> diff --git a/samples/vfs/test-mntinfo.c b/samples/vfs/test-mntinfo.c
> new file mode 100644
> index 000000000000..00fbefae98fa
> --- /dev/null
> +++ b/samples/vfs/test-mntinfo.c

> +/*
> + * Display a mount and then recurse through its children.
> + */
> +static void display_mount(unsigned int mnt_id, unsigned int depth, char *path)
> +{
> +	struct fsinfo_mount_child *children;
> +	struct fsinfo_mount_info info;
> +	struct fsinfo_ids ids;
> +	unsigned int d;
> +	size_t ch_size, p_size;
> +	int i, n, s;
> +
> +	get_attr(mnt_id, FSINFO_ATTR_MOUNT_INFO, &info, sizeof(info));
> +	get_attr(mnt_id, FSINFO_ATTR_IDS, &ids, sizeof(ids));
> +	if (depth > 0)
> +		printf("%s", tree_buf);
> +
> +	s = strlen(path);
> +	printf("%s", !s ? "\"\"" : path);
> +	if (!s)
> +		s += 2;
> +	s += depth;
> +	if (s < 40)
> +		s = 40 - s;
> +	else
> +		s = 1;
> +	printf("%*.*s", s, s, "");
> +
> +	printf("%8x %8x %s %x:%x",
> +	       info.mnt_id, info.notify_counter,
> +	       ids.f_fs_name, ids.f_dev_major, ids.f_dev_minor);
> +	putchar('\n');
> +
> +	children = get_attr_alloc(mnt_id, FSINFO_ATTR_MOUNT_CHILDREN, 0, &ch_size);
> +	n = ch_size / sizeof(children[0]) - 1;
> +
> +	bar_buf[depth + 1] = '|';
> +	if (depth > 0) {
> +		tree_buf[depth - 4 + 1] = bar_buf[depth - 4 + 1];
> +		tree_buf[depth - 4 + 2] = ' ';
> +	}
> +
> +	tree_buf[depth + 0] = ' ';
> +	tree_buf[depth + 1] = '\\';
> +	tree_buf[depth + 2] = '_';
> +	tree_buf[depth + 3] = ' ';
> +	tree_buf[depth + 4] = 0;
> +	d = depth + 4;
> +
> +	for (i = 0; i < n; i++) {
> +		if (i == n - 1)
> +			bar_buf[depth + 1] = ' ';
> +		path = get_attr_alloc(mnt_id, FSINFO_ATTR_MOUNT_SUBMOUNT, i, &p_size);
> +		display_mount(children[i].mnt_id, d, path + 1);
> +		free(path);
> +	}
> +
> +	free(children);
> +	if (depth > 0) {
> +		tree_buf[depth - 4 + 1] = '\\';
> +		tree_buf[depth - 4 + 2] = '_';
> +	}
> +	tree_buf[depth] = 0;
> +}
> +
> +/*
> + * Find the ID of whatever is at the nominated path.
> + */
> +static unsigned int lookup_mnt_by_path(const char *path)
> +{
> +	struct fsinfo_mount_info mnt;
> +	struct fsinfo_params params = {
> +		.request = FSINFO_ATTR_MOUNT_INFO,
> +	};
> +
> +	if (fsinfo(AT_FDCWD, path, &params, &mnt, sizeof(mnt)) == -1) {
> +		perror(path);
> +		exit(1);
> +	}
> +
> +	return mnt.mnt_id;
> +}
> +
> +/*
> + *
> + */
> +int main(int argc, char **argv)
> +{
> +	unsigned int mnt_id;
> +	char *path;
> +	bool use_mnt_id = false;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "M"))) {
> +		switch (opt) {
> +		case 'M':
> +			use_mnt_id = true;
> +			continue;
> +		}
> +		break;
> +	}
> +
> +	argc -= optind;
> +	argv += optind;
> +
> +	switch (argc) {
> +	case 0:
> +		mnt_id = lookup_mnt_by_path("/");
> +		path = "ROOT";
> +		break;
> +	case 1:
> +		path = argv[0];
> +		if (use_mnt_id) {
> +			mnt_id = strtoul(argv[0], NULL, 0);
> +			break;
> +		}
> +
> +		mnt_id = lookup_mnt_by_path(argv[0]);
> +		break;
> +	default:
> +		printf("Format: test-mntinfo\n");
> +		printf("Format: test-mntinfo <path>\n");
> +		printf("Format: test-mntinfo -M <mnt_id>\n");
> +		exit(2);
> +	}
> +
> +	display_mount(mnt_id, 0, path);
> +	return 0;
> +}
>
>
