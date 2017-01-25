From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4 0/2] Add further ioctl() operations for namespace discovery
Date: Wed, 25 Jan 2017 14:58:35 +1300
Message-ID: <87d1fblx2s.fsf@xmission.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
        <963f76f9-3ae5-b316-e688-00d3e59cad30@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <963f76f9-3ae5-b316-e688-00d3e59cad30@gmail.com> (Michael
        Kerrisk's message of "Wed, 25 Jan 2017 14:03:22 +1300")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> I would like to write code that discovers the namespace setup on a live
> system.  The NS_GET_PARENT and NS_GET_USERNS ioctl() operations added in
> Linux 4.9 provide much of what I want, but there are still a couple of
> small pieces missing. Those pieces are added with this patch series.

So it looks like the -EOVERFLOW change broke your example program.
Causing it to abort if -EOVERFLOW is hit.  Do we really want to return
-EOVERFLOW?  Or do you want to fix your program?

Eric


> Here's an example program that makes use of the new ioctl() operations.
>
> 8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---
> /* ns_capable.c
>
>    (C) 2016 Michael Kerrisk, <mtk.manpages@gmail.com>
>
>    Licensed under the GNU General Public License v2 or later.
>
>    Test whether a process (identified by PID) might (subject to LSM checks)
>    have capabilities in a namespace (identified by a /proc/PID/ns/xxx file).
> */
> #define _GNU_SOURCE
> #include <sched.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/ioctl.h>
> #include <limits.h>
> #include <sys/capability.h>
>
> #ifndef NS_GET_USERNS
> #define NSIO    0xb7
> #define NS_GET_USERNS		_IO(NSIO, 0x1)
> #define NS_GET_PARENT		_IO(NSIO, 0x2)
> #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
> #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
> #endif
>
> #define errExit(msg) 	do { perror(msg); exit(EXIT_FAILURE); \
> 			} while (0)
>
> #define fatal(msg) 	do { fprintf(stderr, "%s\n", msg); \
>      			     exit(EXIT_FAILURE); } while (0)
>
> /* Display capabilities sets of process with specified PID */
>
> static void
> show_cap(pid_t pid)
> {
>     cap_t caps;
>     char *cap_string;
>
>     caps = cap_get_pid(pid);
>     if (caps == NULL)
> 	errExit("cap_get_proc");
>
>     cap_string = cap_to_text(caps, NULL);
>     if (cap_string == NULL)
> 	errExit("cap_to_text");
>
>     printf("Capabilities: %s\n", cap_string);
> }
>
> /* Obtain the effective UID pf the process 'pid' by
>    scanning its /proc/PID/file */
>
> static uid_t
> get_euid_of_process(pid_t pid)
> {
>     char path[PATH_MAX];
>     char line[1024];
>     int uid;
>
>     snprintf(path, sizeof(path), "/proc/%ld/status", (long) pid);
>
>     FILE *fp;
>     fp = fopen(path, "r");
>     if (fp == NULL)
> 	errExit("fopen-/proc/PID/status");
>
>     for (;;) {
> 	if (fgets(line, sizeof(line), fp) == NULL) {
>
> 	    /* Should never happen... */
>
> 	    fprintf(stderr, "Failure scanning %s\n", path);
> 	    exit(EXIT_FAILURE);
> 	}
>
> 	if (strstr(line, "Uid:") == line) {
> 	    sscanf(line, "Uid: %*d %d %*d %*d", &uid);
> 	    return uid;
> 	}
>     }
> }
>
> int
> main(int argc, char *argv[])
> {
>     int ns_fd, userns_fd, pid_userns_fd;
>     int nstype;
>     int next_fd;
>     struct stat pid_stat;
>     struct stat target_stat;
>     char *pid_str;
>     pid_t pid;
>     char path[PATH_MAX];
>
>     if (argc < 2) {
> 	fprintf(stderr, "Usage: %s PID [ns-file]\n", argv[0]);
> 	fprintf(stderr, "\t'ns-file' is a /proc/PID/ns/xxxx file; "
> 		        "if omitted, use the namespace\n"
> 			"\treferred to by standard input "
> 			"(file descriptor 0)\n");
> 	exit(EXIT_FAILURE);
>     }
>
>     pid_str = argv[1];
>     pid = atoi(pid_str);
>
>     if (argc <= 2) {
> 	ns_fd = STDIN_FILENO;
>     } else {
>         ns_fd = open(argv[2], O_RDONLY);
>         if (ns_fd == -1)
> 	    errExit("open-ns-file");
>     }
>
>     /* Get the relevant user namespace FD, which is 'ns_fd' if 'ns_fd' refers
>        to a user namespace, otherwise the user namespace that owns 'ns_fd' */
>
>     nstype = ioctl(ns_fd, NS_GET_NSTYPE);
>     if (nstype == -1)
> 	errExit("ioctl-NS_GET_NSTYPE");
>
>     if (nstype == CLONE_NEWUSER) {
> 	userns_fd = ns_fd;
>     } else {
> 	userns_fd = ioctl(ns_fd, NS_GET_USERNS);
>         if (userns_fd == -1)
> 	    errExit("ioctl-NS_GET_USERNS");
>     }
>
>     /* Obtain 'stat' info for the user namespace of the specified PID */
>
>     snprintf(path, sizeof(path), "/proc/%s/ns/user", pid_str);
>
>     pid_userns_fd = open(path, O_RDONLY);
>     if (pid_userns_fd == -1)
> 	errExit("open-PID");
>
>     if (fstat(pid_userns_fd, &pid_stat) == -1)
> 	errExit("fstat-PID");
>
>     /* Get 'stat' info for the target user namesapce */
>
>     if (fstat(userns_fd, &target_stat) == -1)
> 	errExit("fstat-PID");
>
>     /* If the PID is in the target user namespace, then it has
>        whatever capabilities are in its sets. */
>
>     if (pid_stat.st_dev == target_stat.st_dev &&
> 		pid_stat.st_ino == target_stat.st_ino) {
>         printf("PID is in target namespace\n");
> 	printf("Subject to LSM checks, it has the following capabilities\n");
>
> 	show_cap(pid);
>
> 	exit(EXIT_SUCCESS);
>     }
>
>     /* Otherwise, we need to walk through the ancestors of the target
>        user namespace to see if PID is in an ancestor namespace */
>
>     for (;;) {
> 	int f;
>
> 	next_fd = ioctl(userns_fd, NS_GET_PARENT);
>
> 	if (next_fd == -1) {
> 	    
> 	    /* The error here should be EPERM... */
>
> 	    if (errno != EPERM)
> 	        errExit("ioctl-NS_GET_PARENT");
>
> 	    printf("PID is not in an ancestor namespace\n");
> 	    printf("It has no capabilities in the target namespace\n");
>
> 	    exit(EXIT_SUCCESS);
> 	}
>
>         if (fstat(next_fd, &target_stat) == -1)
> 	    errExit("fstat-PID");
>
> 	/* If the 'stat' info for this user namespace matches the 'stat'
> 	 * info for 'next_fd', then the PID is in an ancestor namespace */
>
>         if (pid_stat.st_dev == target_stat.st_dev &&
> 		    pid_stat.st_ino == target_stat.st_ino)
> 	    break;
>
> 	/* Next time round, get the next parent */
>
> 	f = userns_fd;
> 	userns_fd = next_fd;
> 	close(f);
>     }
>
>     /* At this point, we found that PID is in an ancestor of the target
>        user namespace, and 'userns_fd' refers to the immediate descendant
>        user namespace of PID in the chain of user namespaces from PID to
>        the target user namespace. If the effective UID of PID matches the
>        owner UID of descendant user namespace, then PID has all
>        capabilities in the descendant namespace(s); otherwise, it just has
>        the capabilities that are in its sets. */
>
>     uid_t owner_uid, uid;
>     if (ioctl(userns_fd, NS_GET_OWNER_UID, &owner_uid) == -1) {
> 	perror("ioctl-NS_GET_OWNER_UID");
> 	exit(EXIT_FAILURE);
>     }
>
>     uid = get_euid_of_process(pid);
>
>     printf("PID is in an ancestor namespace\n");
>     if (owner_uid == uid) {
> 	printf("And its effective UID matches the owner "
> 		"of the namespace\n");
> 	printf("Subject to LSM checks, PID has all capabilities in "
> 		"that namespace!\n");
>     } else {
> 	printf("But its effective UID does not match the owner "
> 		"of the namespace\n");
> 	printf("Subject to LSM checks, it has the following capabilities\n");
> 	show_cap(pid);
>     }
>
>     exit(EXIT_SUCCESS);
> }
> 8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---
>
> Michael Kerrisk (2):
>   nsfs: Add an ioctl() to return the namespace type
>   nsfs: Add an ioctl() to return owner UID of a userns
>
>  fs/nsfs.c                 | 15 +++++++++++++++
>  include/uapi/linux/nsfs.h |  9 +++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>
> -- 
> 2.5.5
