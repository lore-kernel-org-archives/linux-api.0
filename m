From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Wed, 13 Jan 2016 13:36:51 +0000
Message-ID: <10839.1452692211@warthog.procyon.org.uk>
References: <1452688062.88154.32.camel@infradead.org> <20151226155014.27615.14985.stgit@desktop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452688062.88154.32.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-ID: <10838.1452692211.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-api@vger.kernel.org

David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> David, is there a way to do that test purely in software without
> needing hardware support? We know that the data might not actually be
> present in all cases... is there an easy test for that case?

I have written a user TPM driver that talks to a userspace TPM implementation
out of the backend.  It's been pushed to the TPM driver guy but I'm not sure
what became of it.  I'll chase it up.

David
