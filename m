From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Subject: Re: [PATCH v18 49/80] c/r: support for UTS namespace
Date: Tue, 29 Sep 2009 22:13:17 +0400
Message-ID: <200909292213.21266@blacky.localdomain>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <1253749920-18673-50-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1253749920-18673-50-git-send-email-orenl@librato.com>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>
List-Id: linux-api@vger.kernel.org

> +static struct uts_namespace *do_restore_uts_ns(struct ckpt_ctx *ctx)
> ...
> +#ifdef CONFIG_UTS_NS
> +	uts_ns = create_uts_ns();
> +	if (!uts_ns) {
> +		uts_ns = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +	down_read(&uts_sem);
> +	name = &uts_ns->name;
> +	memcpy(name->sysname, h->sysname, sizeof(name->sysname));
> +	memcpy(name->nodename, h->nodename, sizeof(name->nodename));
> +	memcpy(name->release, h->release, sizeof(name->release));
> +	memcpy(name->version, h->version, sizeof(name->version));
> +	memcpy(name->machine, h->machine, sizeof(name->machine));
> +	memcpy(name->domainname, h->domainname, sizeof(name->domainname));
> +	up_read(&uts_sem);

Could you please explain what for is this down_read() / up_read() ?
You operate only on local objects: 'name' points to just-created 
uts_ns, 'h' is also local data.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
