From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Possible new execveat(2) Linux syscall
Date: Fri, 21 Nov 2014 02:13:18 -0800
Message-ID: <20141121101318.GG8866@infradead.org>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-54610-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20141116195246.GX22465@brightrain.aerifal.cx>
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>, libc-alpha@sourceware.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On Sun, Nov 16, 2014 at 02:52:46PM -0500, Rich Felker wrote:
> I've been following the discussions so far and everything looks mostly
> okay. There are still issues to be resolved with the different
> semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
> O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
> save the permissions at the time of open and cause them to be used in
> place of the current file permissions at the time of execveat

As far as I can tell we only need the little patch below to make Linux
O_PATH a valid O_SEARCH implementation.  Rich, you said you wanted to
look over it?

For O_EXEC my interpretation is that we basically just need this new
execveat syscall + a patch to add FMODE_EXEC and enforce it.  So we
wouldn't even need the O_PATH|3 hack.  But unless someone more familar
with the arcane details of the Posix language verifies it I'm tempted to
give up trying to help to implent these flags :(

diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..ee24720 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -512,7 +512,7 @@ out_unlock:
 
 SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_raw(fd);
 	int err = -EBADF;
 
 	if (f.file) {
@@ -633,7 +633,7 @@ SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group
 
 SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_raw(fd);
 	int error = -EBADF;
 
 	if (!f.file)
