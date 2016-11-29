From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH v2 4/5] generic: test encrypted file access
Date: Tue, 29 Nov 2016 21:52:10 +0100
Message-ID: <efa324fb-6d0b-aad0-1916-cdf12f0072c0@nod.at>
References: <1480371402-12204-1-git-send-email-ebiggers@google.com>
 <1480371402-12204-5-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480371402-12204-5-git-send-email-ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Eric,

On 28.11.2016 23:16, Eric Biggers wrote:
> +# Also, there are some inconsistencies in which error codes are returned on
> +# different kernel versions and filesystems when trying to create a file or
> +# subdirectory without access to the parent directory's encryption key.  For now
> +# we just accept multiple error codes.

This is something I wanted to ask about some time ago but forgot.
Can we please agree on a clear set of fscrypt related error codes
and document them in the Linux man pages?

Thanks,
//richard
