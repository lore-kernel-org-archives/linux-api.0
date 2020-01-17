From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] fscrypt: reserve flags for hardware-wrapped keys feature
Date: Fri, 17 Jan 2020 00:12:46 -0800
Message-ID: <20200117081246.GA16846@infradead.org>
References: <20200116192008.35766-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200116192008.35766-1-ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Barani Muthukumaran <bmuthuku-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gaurav Kashyap <gaurkash-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 16, 2020 at 11:20:08AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Reserve flags for the hardware-wrapped keys feature which is being
> worked on [1].  FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY will denote that the
> encryption policy needs a hardware-wrapped key to be unlocked.
> FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED will denote that the key being added is
> a hardware-wrapped key.
> 
> This reservation is tentative, and these codepoints may be reused if the
> feature is not upstreamed.

NAK.  While the feature itself sounds really useful we don't just
reserve format bits for code not upstream.
