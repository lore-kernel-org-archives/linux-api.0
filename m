From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv3 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Mon, 9 Mar 2015 15:16:34 +0000
Message-ID: <CAHse=S_kMkiV8hB5Y1=kVGCi3ZusRm5G=EyXhY_+PRycSt7GSw@mail.gmail.com>
References: <1425909612-28034-1-git-send-email-drysdale@google.com>
 <1425909612-28034-4-git-send-email-drysdale@google.com> <54FDAF16.2030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <54FDAF16.2030407@gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, fstests@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 9, 2015 at 2:32 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 03/09/2015 03:00 PM, David Drysdale wrote:
>> Signed-off-by: David Drysdale <drysdale@google.com>
>
> Hi David,
>
> The text looks good insofar as it goes. But, it would be helpful
> to have sentence or to that explains why this flag exists.
> Could you add that, please?
>
> Thanks,
>
> Michael

How about something like:

  This feature allows applications to be sure that the opened file
  is  within  the  specified directory, regardless of the original
  source of the pathname argument.  Some  security-conscious  pro=E2=80=
=90
  grams  may  further ensure this by imposing a system call filter
  (with seccomp(2)) that requires this flag for all open()  opera=E2=80=
=90
  tions,  so  that the program cannot open files outside of speci=E2=80=
=90
  fied directories even if subverted.

(Also, I realize that I somehow failed to notice that the flags
are listed in alphabetical order, so I'll move the text up, as
in the updated diff below).

Thanks,
David

---
 man2/open.2 | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/man2/open.2 b/man2/open.2
index 956531b24b26..ece1fa90775a 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -201,6 +201,43 @@ See
 for further details.
 See also BUGS, below.
 .TP
+.B O_BENEATH " (since Linux 4.??)"
+Ensure that the
+.I pathname
+is beneath the current working directory (for
+.BR open (2))
+or the
+.I dirfd
+(for
+.BR openat (2)).
+If the
+.I pathname
+is absolute or contains a path component of "..", the
+.BR open ()
+fails with the error
+.BR EPERM.
+This occurs even if ".." path component would not actually
+escape the original directory; for example, a
+.I pathname
+of "subdir/../filename" would be rejected.
+Path components that are symbolic links to absolute paths, or that are
+relative paths containing a ".." component, will also cause the
+.BR open ()
+operation to fail with the error
+.BR EPERM.
+
+This feature allows applications to be sure that the opened file is
+within the specified directory, regardless of the original source of t=
he
+.I pathname
+argument.
+Some security-conscious programs may further ensure
+this by imposing a system call filter (with
+.BR seccomp (2))
+that requires this flag for all
+.BR open ()
+operations, so that the program cannot open files outside of
+specified directories even if subverted.
+.TP
 .BR O_CLOEXEC " (since Linux 2.6.23)"
 .\" NOTE! several other man pages refer to this text
 Enable the close-on-exec flag for the new file descriptor.
@@ -984,6 +1021,13 @@ did not match the owner of the file and the
caller was not privileged
 The operation was prevented by a file seal; see
 .BR fcntl (2).
 .TP
+.B EPERM
+The
+.B O_BENEATH
+flag was specified and the
+.I pathname
+was not beneath the relevant directory.
+.TP
 .B EROFS
 .I pathname
 refers to a file on a read-only filesystem and write access was
--=20
2.2.0.rc0.207.ga3a616c
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
