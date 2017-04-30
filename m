From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [v2] fscrypt: Remove __packed from fscrypt_policy
Date: Sun, 30 Apr 2017 02:16:46 -0400
Message-ID: <20170430061646.6ereidy5rk4wzso5@thunk.org>
References: <20170406231428.154187-1-joerichey94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170406231428.154187-1-joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Richey <joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 06, 2017 at 04:14:28PM -0700, Joe Richey wrote:
> From: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> This commit removes __packed from fscrypt_policy as it does not contain
> any implicit padding and does not refer to an on-disk structure. Even
> though this is a change to a UAPI file, no users will be broken as the
> structure doesn't change.
> 
> Signed-off-by: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

					- Ted
