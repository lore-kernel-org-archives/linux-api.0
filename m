From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Fri, 15 May 2015 13:32:03 +0200
Message-ID: <1431689523.1769.1.camel@samsung.com>
References: <cover.1431671529.git.luto@kernel.org>
 <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Christoph Lameter <cl@linux.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On czw, 2015-05-14 at 23:39 -0700, Andy Lutomirski wrote:
> @@ -696,10 +729,18 @@ static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>  	     uid_eq(old->suid, root_uid)) &&
>  	    (!uid_eq(new->uid, root_uid) &&
>  	     !uid_eq(new->euid, root_uid) &&
> -	     !uid_eq(new->suid, root_uid)) &&
> -	    !issecure(SECURE_KEEP_CAPS)) {
> -		cap_clear(new->cap_permitted);
> -		cap_clear(new->cap_effective);
> +	     !uid_eq(new->suid, root_uid))) {
> +		if (!issecure(SECURE_KEEP_CAPS)) {
> +			cap_clear(new->cap_permitted);
> +			cap_clear(new->cap_effective);
> +		}
> +
> +		/*
> +		 * Pre-ambient programs except setresuid to nonroot followed

I think you meant "expect". This typo changes the meaning of the
sentence.

> +		 * by exec to drop capabilities.  We should make sure that
> +		 * this remains the case.
> +		 */
> +		cap_clear(new->cap_ambient);
>  	}


-- 
Lukasz Pawelczyk


