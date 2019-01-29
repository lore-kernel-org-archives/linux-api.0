From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFD] A mount api that notices previous mounts
Date: Tue, 29 Jan 2019 15:44:22 -0600
Message-ID: <87va2716mh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--=-=-=
Content-Type: text/plain


All,

With the existing mount API it is possible to mount a filesystem
like:

mount -t ext4 /dev/sda1 -o user_xattr /some/path
mount -t ext4 /dev/sda1 -o nouser_xattr /some/other/path

And have both mount commands succeed and have two mounts of the same
filesystem.  If the mounter is not attentive or the first mount is added
earlier it may not be immediately noticed that a mount option that is
needed for the correct operation or the security of the system is lost.

We have seen this failure mode with both devpts and proc.  So it is not
theoretical, and it has resulted in CVEs.

In some cases the existing mount API (such as a conflict between ro and
rw) handles this by returning -EBUSY.  So we may be able to correct this
in the existing mount API.  But it is always very tricky to to get
adequate testing for a change like that to avoid regressions, so I am
proposing we change this in the new mount api.

This has been brought up before and I have been told it is technically
infeasible to make this work.  To counter that I have sat down and
implemented it.

The basic idea is:
 - get a handle to a filesystem
   (passing enough options to uniquely identify the super block).
   Also capture enough state in the file handle to let you know if
   the file system has it's mount options changed between system calls.
   (essentially this is just the fs code that calls sget)

 - If the super block has not been configured allow setting the file
   systems options.

 - If the super block has already been configured require reading the
   file systems mount options before setting/updating the file systems
   mount options.

To complement that I have functionality that:
 - Allows reading a file systems current mount options.
 - Allows reading the mount options that are needed to get a handle to
   the filesystem.  For most filesystems it is just the block device
   name.  For nfs is is essentially all mount options.  For btrfs
   it is the block device name, and the "devices=" mount option for
   secondary block device names.

Please find below a tree where all of this is implemented and working.
Not all file systems have been converted but the most of the unconverted
ones are just a couple minutes work as I have converted all of the file
system mount helper routines.

Also please find below an example mount program that takes the same set
of mount options as mount(8) today and mounts filesystems with the
proposed new mount api.
 - Without having any filesystem mount knowledge it sucessfully figures

out which system calls different mount options needs to be applied
   to.

- Without having any filesystem specific knowledge in most cases it
   can detect if a mount option you specify is already specified to an
   existing mount or not.  For duplicates it can detect it ignores them.
   For the other cases it fails the mount as it thinks the mount options
   are different.

 - Which demonstrates it safe to put the detection and remediation of
   multiple mount commands resolving to the same filesystem in user
   space.

I really don't care whose code gets used as long as it works.  I do very
much care that we don't add a new mount api that has the confusion flaws
of the existing mount api.

Along the way I have also detected a lot of room for improvement on the
mount path for filesystems.  Those cleanup patches are in my tree below
and will be extracting them and sending them along shortly.

Comments?

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git no-losing-mount-options-proof-of-concept


--=-=-=
Content-Type: text/x-csrc
Content-Disposition: attachment; filename=example_mount.c

/* gcc -Wall -O2 -g example_mount.c -o example_mount */
#define _ATFILE_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/syscall.h>

#ifdef __x86_64__
# ifndef __NR_open_tree
#  define __NR_open_tree 335
# endif
# ifndef __NR_move_mount
#  define __NR_move_mount 336
# endif
# ifndef __NR_fsopen
#  define  __NR_fsopen 337
# endif
# ifndef __NR_fsspecifiers
#  define  __NR_fsspecifiers 338
# endif
# ifndef __NR_fsinstance
#  define  __NR_fsinstance 339
# endif
# ifndef __NR_fspick
#  define  __NR_fspick 340
# endif
# ifndef __NR_fsset
#  define  __NR_fsset 341
# endif
# ifndef __NR_fsmount
#  define  __NR_fsmount 342
# endif
# ifndef __NR_fsoptions
#  define  __NR_fsoptions 343
# endif
# ifndef __NR_fsname
#  define  __NR_fsname 344
# endif
# ifndef __NR_fstype
#  define  __NR_fstype 345
# endif
#endif /* x86_64 */

#ifndef MOVE_MOUNT_F_SYMLINKS
# define MOVE_MOUNT_F_SYMLINKS		0x00000001 /* Follow symlinks on from path */
#endif
#ifndef MOVE_MOUNT_F_AUTOMOUNTS
# define MOVE_MOUNT_F_AUTOMOUNTS	0x00000002 /* Follow automounts on from path */
#endif
#ifndef MOVE_MOUNT_F_EMPTY_PATH
# define MOVE_MOUNT_F_EMPTY_PATH	0x00000004 /* Empty from path permitted */
#endif
#ifndef MOVE_MOUNT_T_SYMLINKS
# define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
#endif
#ifndef MOVE_MOUNT_T_AUTOMOUNTS
# define MOVE_MOUNT_T_AUTOMOUNTS	0x00000020 /* Follow automounts on to path */
#endif
#ifndef MOVE_MOUNT_T_EMPTY_PATH
# define MOVE_MOUNT_T_EMPTY_PATH	0x00000040 /* Empty to path permitted */
#endif

int open_tree(int dfd, const char *path, unsigned int flags)
{
	return syscall(__NR_open_tree, dfd, path, flags);
}

int move_mount(int from_dfd, const char *from_path,
	       int to_dfd, const char *to_path, unsigned int flags)
{
	return syscall(__NR_move_mount, from_dfd, from_path, to_dfd, to_path, flags);
}

int fsopen(const char *type)
{
	return syscall(__NR_fsopen, type);
}


int fsspecifiers(int driverfd, char *specifiers, size_t specifiers_len)
{
	return syscall(__NR_fsspecifiers, driverfd, specifiers, specifiers_len);
}


int fsinstance(int driverfd, const char *name, const char *specifiers)
{
	return syscall(__NR_fsinstance, driverfd, name, specifiers);
}


int fspick(int dfd, const char *path, unsigned int flags)
{
	return syscall(__NR_fspick, dfd, path, flags);
}

int fsset(int instancefd, const char *options)
{
	return syscall(__NR_fsset, instancefd, options);
}

int fsmount(int instancefd, const char *options)
{
	return syscall(__NR_fsmount, instancefd, options);
}

int fsoptions(int instancefd, char *options, size_t options_len)
{
	return syscall(__NR_fsoptions, instancefd, options, options_len);
}

int fsname(int instancefd, char *name, size_t name_len)
{
	return syscall(__NR_fsname, instancefd, name, name_len);
}

int fstype(int instancefd, char *type, size_t type_len)
{
	return syscall(__NR_fstype, instancefd, type, type_len);
}


static const char *mount_vec[] = {
	"ro",
	"rw",
	"nosuid",
	"nodev",
	"dev",
	"noexec",
	"nodiratime",
	"diratime",
	"noatime",
	"relatime",
	"strictatime",
	NULL
};

static const char *joint_vec[] = {
	"ro",
	"rw",
	NULL
};

static char *parse_mnt_opt(char *opt, char *end)
{
	char *p, *equal = NULL;
	int open_quote;

	open_quote = 0;
	for (p = opt; (p < end) && *p; p++) {
		if (equal && (*p == '"'))
			open_quote ^= 1;
		if (open_quote)
			continue;
		if (!equal && (*p == '='))
			equal = p;
		else if (*p == ',') {
			end = p;
			break;
		}
	}
	/* Unbalaned quotes? */
	if (open_quote) {
		errno = -EINVAL;
		return NULL;
	}

	return end;
}

int split_options(char *options, const char ***optvp)
{
	const char **vec = NULL;
	size_t count = 0, index = 0;
	char *opt, *end, *comma;

	opt = options;
	end = opt + strlen(opt);
	for (comma = opt; comma != end; opt = comma + 1) {
		comma = parse_mnt_opt(opt, end);
		if (!comma)
			return -1;

		if (opt == comma)
			continue;

		count++;
	}

	vec = calloc(count + 1, sizeof(char *));
	if (!vec)
		return -1;

	opt = options;
	for (comma = opt; comma != end; opt = comma + 1) {
		comma = parse_mnt_opt(opt, end);
		if (!comma)
			abort();

		if (opt == comma)
			continue;

		*comma = '\0';
		vec[index++] = opt;
	}
	vec[index] = NULL;
	*optvp = vec;
	return 0;
}

static char *join_options(const char *optv[])
{
	char *flat, *flat_opt;
	const char **opt;
	size_t bytes = 0;

	for (opt = optv; *opt; opt++) {
		size_t len = strlen(*opt);
		/* An extra byte for the comma */
		bytes += len + 1;
	}

	flat_opt = flat = malloc(bytes + 1);
	if (!flat) {
		fprintf(stderr, "malloc failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	for (opt = optv; *opt; opt++) {
		size_t len = strlen(*opt);
		if (flat_opt != flat) {
			*flat_opt = ',';
			flat_opt += 1;
		}
		memcpy(flat_opt, *opt, len);
		flat_opt += len;
	}
	*flat_opt = '\0';
	return flat;
}


void build_option_strings(int dfd,
	const char **specifiers, const char **ioptions, const char **moptions,
	const char *input_options)
{
	char accepted_specifiers[1024*1024];
	const char **ovec, **asvec, **svec, **ivec, **mvec;
	const char **opt, **sopt, **iopt, **mopt;
	char *options;
	size_t count;
	int ret;

	ret = fsspecifiers(dfd, accepted_specifiers, sizeof(accepted_specifiers));
	if (ret < 0) {
		fprintf(stderr, "fsspecifiers failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	options = strdup(input_options);
	if (!options) {
		fprintf(stderr, "strdup failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}
	if (split_options(options, &ovec) != 0) {
		fprintf(stderr, "split_options failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}
	if (split_options(accepted_specifiers, &asvec) != 0) {
		fprintf(stderr, "split_options failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	for (count = 0, opt = ovec; *opt; opt++) {
		count++;
	}

	svec = calloc(count + 1, sizeof(char *));
	if (!svec) {
		fprintf(stderr, "calloc failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}
	ivec = calloc(count + 1, sizeof(char *));
	if (!ivec) {
		fprintf(stderr, "calloc failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}
	mvec = calloc(count + 1, sizeof(char *));
	if (!mvec) {
		fprintf(stderr, "calloc failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	sopt = svec;
	iopt = ivec;
	mopt = mvec;
	for (opt = ovec; *opt; opt++) {
		const char **topt;
		const char *sep;
		int len;

		sep = strchr(*opt, '=');
		len = sep ? sep - *opt : strlen(*opt);

		/* Is the option both a mount an a normal option? */
		for (topt = joint_vec; *topt; topt++) {
			if (strcmp(*opt, *topt) == 0) {
				*mopt++ = *opt;
				goto fsoption;
			}
		}
		/* Is the option just a mount option? */
		for (topt = mount_vec; *topt; topt++) {
			if (strcmp(*opt, *topt) == 0) {
				*mopt++ = *opt;
				goto placed;
			}
		}
	fsoption:
		for (topt = asvec; *topt; topt++) {
			char tail;
			if (strncmp(*opt, *topt, len) != 0)
				continue;
			tail = (*opt)[len];
			if (tail != (sep ? '=' : '\0'))
				continue;
			*sopt++ = *opt;
			goto placed;
		}
		*iopt++ = *opt;
	placed:
		;
	}
	*sopt = NULL;
	*iopt = NULL;
	*mopt = NULL;
	*specifiers = join_options(svec);
	*ioptions = join_options(ivec);
	*moptions = join_options(mvec);
	free(svec);
	free(ivec);
	free(mvec);
	return;
}

int main(int argc, char **argv)
{
	const char *type, *name, *specifiers, *options, *moptions, *dir;
	const char *input_options;
	int dfd, ifd, mfd, ret;

	if (argc != 5) {
		fprintf(stderr, "usage: new_mount <type> <name> <options> <dir>\n");
		return EXIT_FAILURE;
	}

	type = argv[1];
	name = argv[2];
	input_options = argv[3];
	dir = argv[4];

	dfd = fsopen(type);
	if (dfd < 0) {
		fprintf(stderr, "fsopen failed: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}

	build_option_strings(dfd, &specifiers, &options, &moptions, input_options);

	ifd = fsinstance(dfd, name, specifiers);
	if (ifd < 0) {
		fprintf(stderr, "fsinstance failed: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}

	errno = 0;
	ret = fsset(ifd, options);
	if (ret && (errno != ESTALE)) {
		fprintf(stderr, "fsset.1 failed: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}
	if (errno == ESTALE) {
		char existing_options[1024*1024];
		const char **evec, **nvec, **eopt, **nopt;
		char *new_options;
		ret = fsoptions(ifd, existing_options, sizeof(existing_options));
		if (ret < 0) {
			fprintf(stderr, "fsoptions failed: %s\n", strerror(errno));
			return EXIT_FAILURE;
		}

		new_options = strdup(options);
		if (!new_options) {
			fprintf(stderr, "strdup failed: %s\n", strerror(errno));
			return EXIT_FAILURE;
		}
		if (split_options(existing_options, &evec) != 0) {
			fprintf(stderr, "split_options failed: %s\n", strerror(errno));
			return EXIT_FAILURE;
		}
		if (split_options(new_options, &nvec) != 0) {
			fprintf(stderr, "split_options failed: %s\n", strerror(errno));
			return EXIT_FAILURE;
		}
		for (nopt = nvec; *nopt; nopt++) {
			for (eopt = evec; *eopt; eopt++) {
				if (strcmp(*eopt, *nopt) == 0)
					goto found;
			}
			fprintf(stderr, "Setting '%s' would change the existing file system options\n",
				*nopt);
			return EXIT_FAILURE;
		found:
			;
		}
		ret = fsset(ifd, options);
		if (ret) {
			fprintf(stderr, "fsset.2 failed: %s\n", strerror(errno));
			return EXIT_FAILURE;
		}

	}

	mfd = fsmount(ifd, moptions);
	if (mfd < 0) {
		fprintf(stderr, "fsmount failed: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}
	close(ifd);

	ret = move_mount(mfd, "", AT_FDCWD, dir, MOVE_MOUNT_F_EMPTY_PATH);
	if (ret) {
		fprintf(stderr, "move_mount failed: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}

	return 0;
}

--=-=-=
Content-Type: text/plain



Eric


--=-=-=--
