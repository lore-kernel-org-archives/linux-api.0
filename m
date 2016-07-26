From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Tue, 26 Jul 2016 12:11:02 -0700
Message-ID: <20160726191101.GB328@outlook.office365.com>
References: <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<87r3ahepb4.fsf@x220.int.ebiederm.org>
	<20160726025455.GC26206@outlook.office365.com>
	<3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
	<20160726182524.GA328@outlook.office365.com>
	<20160726183224.GN24913@odin.tremily.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726183224.GN24913-q4NCUed9G3sTnwFZoN752g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 26, 2016 at 11:32:25AM -0700, W. Trevor King wrote:
> On Tue, Jul 26, 2016 at 11:25:24AM -0700, Andrew Vagin wrote:
> > Sure. If a process wants to compare two namespaces, it needs to get file
> > descriptors for them (open /proc/PID/ns/XXX, use new ioctl-s, find a
> > process which has them),
> > and then it calls kcmp(pid1, pid2, KCMP_NSFD, ns_fd1, ns_fd2)
> 
> If you use the new ioctl-s to get ns_fd2, do you walk your local /proc
> to find pid2?

If you use the new ioctl-s to get nf_fd2, you will have it in the
current process, so pid2 will be getpid().

pidX identifies a process where to find fdX.

man 2 kcmp:
 The kcmp() system call can be used to check whether the  two processes
 identified  by  pid1  and  pid2 share a kernel resource such as virtual
 memory, file descriptors, and so on.

> 
> Cheers,
> Trevor
> 
> -- 
> This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
> For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy
