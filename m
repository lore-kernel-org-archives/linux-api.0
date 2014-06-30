From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/5] man-pages: open.2: describe O_BENEATH_ONLY flag
Date: Mon, 30 Jun 2014 15:22:48 -0700
Message-ID: <CALCETrWDobS1q68fPN_bagvRyBq=jykrrMNYB2H=uSF5uZTmhw@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-13-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-13-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  man2/open.2 | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/man2/open.2 b/man2/open.2
> index 3824ab5be1f0..ba0da01c1a4f 100644
> --- a/man2/open.2
> +++ b/man2/open.2
> @@ -713,7 +713,7 @@ in a fully formed state (using
>  as described above).
>  .RE
>  .IP
> -.B O_TMPFILE
> +.B O_TMPFILE " (since Linux 3.??)"
>  requires support by the underlying filesystem;
>  only a subset of Linux filesystems provide that support.
>  In the initial implementation, support was provided in
> @@ -723,6 +723,31 @@ XFS support was added
>  .\" commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
>  in Linux 3.15.
>  .TP
> +.B O_BENEATH_ONLY
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
> +.BR EACCES.
> +This occurs even if ".." path component would not actually
> +escape the original directory; for example, a
> +.I pathname
> +of "subdir/../filename" would be rejected.
> +Path components that are symbolic links to absolute paths, or that are
> +relative paths containing a ".." component, are cause the

"are cause" is a typo.  Do you mean "will also cause"?

--Andy
