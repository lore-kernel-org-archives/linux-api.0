From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 16:30:47 +0000
Message-ID: <20190207163047.GE2217@ZenIV.linux.org.uk>
References: <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <0d2e5085-32ff-e86e-d628-6000071fd132@kernel.dk>
 <20190206010104.GV2217@ZenIV.linux.org.uk>
 <608c1102-5818-e38c-cfc7-b1cec5a1ecb4@kernel.dk>
 <20190207040547.GX2217@ZenIV.linux.org.uk>
 <51f167c6-aacc-dd5b-4481-7168c6f8b413@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <51f167c6-aacc-dd5b-4481-7168c6f8b413@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 09:14:41AM -0700, Jens Axboe wrote:

> I created a small app to do just that, and ran it and verified that
> ->release() is called and the io_uring is released as expected. This
> is run on the current -git branch, which has a socket backing for
> the io_uring fd itself, but not for the registered files.
> 
> What am I missing here? Attaching the program as a reference.

> int main(int argc, char *argv[])
> {
> 	int sp[2], pid, ring_fd, ret;
> 
> 	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
> 		perror("Failed to create Unix-domain socket pair\n");
> 		return 1;
> 	}
> 
> 	ring_fd = get_ring_fd();
> 	if (ring_fd < 0)
> 		return 1;
> 
> 	ret = io_uring_register_files(ring_fd, sp[0], sp[1]);
> 	if (ret < 0) {
> 		perror("register files");
> 		return 1;
> 	}
> 
> 	pid = fork();
> 	if (pid) {
> 		printf("Sending fd %d\n", ring_fd);
> 
> 		send_fd(sp[0], ring_fd);
> 	} else {
> 		int fd;
> 
> 		fd = recv_fd(sp[1]);

Well, yes - once you receive it, you obviously have no references
sitting in SCM_RIGHTS anymore.

Get rid of recv_fd() there (along with fork(), while we are at it - what's
it for?) and just do send_fd + these 3 close (or just exit, for that matter).

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
