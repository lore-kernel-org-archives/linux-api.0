From: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] leftpad.2: Document new syscall
Date: Fri, 8 Apr 2016 20:10:33 +0200
Message-ID: <5707F419.6060300@gmx.de>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-3-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459463613-32473-3-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Walter <dwalter-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/01/2016 12:33 AM, Richard Weinberger wrote:
> From: Daniel Walter <dwalter-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> 
> Signed-off-by: Daniel Walter <dwalter-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> Signed-off-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> ---
>  man2/leftpad.2 | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 man2/leftpad.2
> 
> diff --git a/man2/leftpad.2 b/man2/leftpad.2
> new file mode 100644
> index 0000000..ff5f401
> --- /dev/null
> +++ b/man2/leftpad.2
> @@ -0,0 +1,55 @@
> +.\" Copyright (c) 2016 sigma-star gmbh
> +.\" (office-S6VGOU4v5edDinCvNWH78Q@public.gmane.org)
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" This is free documentation; you can redistribute it and/or
> +.\" modify it under the terms of the GNU General Public License as
> +.\" published by the Free Software Foundation; either version 2 of
> +.\" the License, or (at your option) any later version.
> +.\"
> +.\" The GNU General Public License's references to "object code"
> +.\" and "executables" are to be interpreted as the output of any
> +.\" document formatting or typesetting system, including
> +.\" intermediate and printed output.
> +.\"
> +.\" This manual is distributed in the hope that it will be useful,
> +.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> +.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +.\" GNU General Public License for more details.
> +.\"
> +.\" You should have received a copy of the GNU General Public
> +.\" License along with this manual; if not, see
> +.\" <http://www.gnu.org/licenses/>.
> +.\" %%%LICENSE_END
> +.\"
> +.TH LEFTPAD 2 2016-04-01 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +leftpad
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/types.h>
> +
> +.BI "int leftpad(char *src, char pad, char *dst, size_t dst_len);
> +.fi
> +.SH DESCRIPTION
> +This function provides left padding for strings.
> +.LP
> +The string in
> +.I src
> +will be left padded with the chosen padding character
> +.I pad
> +and stored in
> +.I dst
> + .
> +.SH RETURN VALUE
> +On success, returns the number of padding characters added.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +The size of the destination buffer
> +.I dst
> +is shorter than the source string
> +.I src
> + . Or the destination string is longer than 4096 bytes.

Why should the call be limited to an arbitrary number of 4096 bytes?

There is no such limit in malloc so why should we need one here?

NAK

Best regards

Heinrich Schuchardt

> +.SH SEE ALSO
> +.BR snprintf (3)
> 
