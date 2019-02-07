From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 09:14:41 -0700
Message-ID: <51f167c6-aacc-dd5b-4481-7168c6f8b413@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <0d2e5085-32ff-e86e-d628-6000071fd132@kernel.dk>
 <20190206010104.GV2217@ZenIV.linux.org.uk>
 <608c1102-5818-e38c-cfc7-b1cec5a1ecb4@kernel.dk>
 <20190207040547.GX2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B3C7112CC1CD3B17843EA982"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190207040547.GX2217@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------B3C7112CC1CD3B17843EA982
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2/6/19 9:05 PM, Al Viro wrote:
> On Wed, Feb 06, 2019 at 10:56:41AM -0700, Jens Axboe wrote:
>> On 2/5/19 6:01 PM, Al Viro wrote:
>>> On Tue, Feb 05, 2019 at 05:27:29PM -0700, Jens Axboe wrote:
>>>
>>>> This should be better, passes some basic testing, too:
>>>>
>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=io_uring&id=01a93aa784319a02ccfa6523371b93401c9e0073
>>>>
>>>> Verified that we're grabbing the right refs, and don't hold any
>>>> ourselves. For the file registration, forbid registration of the
>>>> io_uring fd, as that is pointless and will introduce a loop regardless
>>>> of fd passing.
>>>
>>> *shrug*
>>>
>>> So pass it to AF_UNIX socket and register _that_ - does't change the
>>> underlying problem.
>>
>> Maybe I'm being dense here, but it's an f_op match. Should catch a
>> passed fd as well, correct?
> 
> f_op match on _what_?
> 
>> With that, how can there be a loop?
> 
> 	io_uring_fd = ....
> 	socketpair(PF_UNIX, SOCK_STREAM, 0, sock_fds);
> 	register sock_fds[0] and sock_fds[1] to io_uring_fd
> 	send SCM_RIGHTS datagram with io_uring_fd to sock_fds[0]
> 	close sock_fds[0], sock_fds[1] and io_uring_fd
> 
> And there's your unreachable loop.

I created a small app to do just that, and ran it and verified that
->release() is called and the io_uring is released as expected. This
is run on the current -git branch, which has a socket backing for
the io_uring fd itself, but not for the registered files.

What am I missing here? Attaching the program as a reference.

-- 
Jens Axboe


--------------B3C7112CC1CD3B17843EA982
Content-Type: text/x-csrc;
 name="viro.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="viro.c"

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <signal.h>
#include <inttypes.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <linux/fs.h>

struct io_sqring_offsets {
	__u32 head;
	__u32 tail;
	__u32 ring_mask;
	__u32 ring_entries;
	__u32 flags;
	__u32 dropped;
	__u32 array;
	__u32 resv[3];
};

struct io_cqring_offsets {
	__u32 head;
	__u32 tail;
	__u32 ring_mask;
	__u32 ring_entries;
	__u32 overflow;
	__u32 cqes;
	__u32 resv[4];
};

struct io_uring_params {
	__u32 sq_entries;
	__u32 cq_entries;
	__u32 flags;
	__u32 sq_thread_cpu;
	__u32 sq_thread_idle;
	__u32 resv[5];
	struct io_sqring_offsets sq_off;
	struct io_cqring_offsets cq_off;
};

#define IORING_REGISTER_FILES		2

#define __NR_sys_io_uring_setup		425
#define __NR_sys_io_uring_register	427

static int io_uring_register_files(int ring_fd, int fd1, int fd2)
{
	__s32 *fds;

	fds = calloc(2, sizeof(__s32));
	fds[0] = fd1;
	fds[1] = fd2;

	return syscall(__NR_sys_io_uring_register, ring_fd,
			IORING_REGISTER_FILES, fds, 2);
}

static int io_uring_setup(unsigned entries, struct io_uring_params *p)
{
	return syscall(__NR_sys_io_uring_setup, entries, p);
}

static int get_ring_fd(void)
{
	struct io_uring_params p;
	int fd;

	memset(&p, 0, sizeof(p));

	fd = io_uring_setup(2, &p);
	if (fd < 0) {
		perror("io_uring_setup");
		return -1;
	}

	return fd;
}

static void send_fd(int socket, int fd)
{
	char buf[CMSG_SPACE(sizeof(fd))];
	struct cmsghdr *cmsg;
	struct msghdr msg;

	memset(buf, 0, sizeof(buf));
	memset(&msg, 0, sizeof(msg));

	msg.msg_control = buf;
	msg.msg_controllen = sizeof(buf);

	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_RIGHTS;
	cmsg->cmsg_len = CMSG_LEN(sizeof(fd));

	memmove(CMSG_DATA(cmsg), &fd, sizeof(fd));

	msg.msg_controllen = CMSG_SPACE(sizeof(fd));

	if (sendmsg(socket, &msg, 0) < 0)
		perror("sendmsg");
}

static int recv_fd(int socket)
{
	struct msghdr msg;
	char c_buffer[256];
	struct cmsghdr *cmsg;
	int fd;

	memset(&msg, 0, sizeof(msg));

	msg.msg_control = c_buffer;
	msg.msg_controllen = sizeof(c_buffer);

	if (recvmsg(socket, &msg, 0) < 0)
		perror("recvmsg\n");

	cmsg = CMSG_FIRSTHDR(&msg);
	memmove(&fd, CMSG_DATA(cmsg), sizeof(fd));
	return fd;
}

int main(int argc, char *argv[])
{
	int sp[2], pid, ring_fd, ret;

	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
		perror("Failed to create Unix-domain socket pair\n");
		return 1;
	}

	ring_fd = get_ring_fd();
	if (ring_fd < 0)
		return 1;

	ret = io_uring_register_files(ring_fd, sp[0], sp[1]);
	if (ret < 0) {
		perror("register files");
		return 1;
	}

	pid = fork();
	if (pid) {
		printf("Sending fd %d\n", ring_fd);

		send_fd(sp[0], ring_fd);
	} else {
		int fd;

		fd = recv_fd(sp[1]);
		printf("Got fd %d\n", fd);
		close(fd);
	}

	usleep(500000);
	close(ring_fd);
	close(sp[0]);
	close(sp[1]);
	return 0;
}

--------------B3C7112CC1CD3B17843EA982--

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
