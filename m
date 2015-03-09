From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCHv3 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Mon, 09 Mar 2015 15:32:54 +0100
Message-ID: <54FDAF16.2030407@gmail.com>
References: <1425909612-28034-1-git-send-email-drysdale@google.com> <1425909612-28034-4-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425909612-28034-4-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015 03:00 PM, David Drysdale wrote:
> Signed-off-by: David Drysdale <drysdale@google.com>

Hi David,

The text looks good insofar as it goes. But, it would be helpful
to have sentence or to that explains why this flag exists.
Could you add that, please?

Thanks,

Michael

> ---
>  man2/open.2 | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/man2/open.2 b/man2/open.2
> index 956531b24b26..be40dd7710df 100644
> --- a/man2/open.2
> +++ b/man2/open.2
> @@ -716,6 +716,31 @@ XFS support was added
>  .\" commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
>  in Linux 3.15.
>  .TP
> +.B O_BENEATH " (since Linux 3.??)"
> +Ensure that the
> +.I pathname
> +is beneath the current working directory (for
> +.BR open (2))
> +or the
> +.I dirfd
> +(for
> +.BR openat (2)).
> +If the
> +.I pathname
> +is absolute or contains a path component of "..", the
> +.BR open ()
> +fails with the error
> +.BR EPERM.
> +This occurs even if ".." path component would not actually
> +escape the original directory; for example, a
> +.I pathname
> +of "subdir/../filename" would be rejected.
> +Path components that are symbolic links to absolute paths, or that are
> +relative paths containing a ".." component, will also cause the
> +.BR open ()
> +operation to fail with the error
> +.BR EPERM.
> +.TP
>  .B O_TRUNC
>  If the file already exists and is a regular file and the access mode allows
>  writing (i.e., is
> @@ -984,6 +1009,13 @@ did not match the owner of the file and the caller was not privileged
>  The operation was prevented by a file seal; see
>  .BR fcntl (2).
>  .TP
> +.B EPERM
> +The
> +.B O_BENEATH
> +flag was specified and the
> +.I pathname
> +was not beneath the relevant directory.
> +.TP
>  .B EROFS
>  .I pathname
>  refers to a file on a read-only filesystem and write access was
> --
> 2.2.0.rc0.207.ga3a616c
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
