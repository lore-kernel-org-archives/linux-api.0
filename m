From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/11] selinux: Implement the watch_key security hook [ver #7]
Date: Fri, 30 Aug 2019 15:23:41 +0100
Message-ID: <5368.1567175021@warthog.procyon.org.uk>
References: <21eb33e8-5624-0124-8690-bbea41a1b589@tycho.nsa.gov> <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk> <156717352079.2204.16378075382991665807.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21eb33e8-5624-0124-8690-bbea41a1b589@tycho.nsa.gov>
Content-ID: <5366.1567175021.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	u32 sid = cred_sid(current_cred());
> 
> How does this differ from current_sid()?
> 
> And has current_sid() not been converted to use selinux_cred()? Looks like
> selinux_kernfs_init_security() also uses current_security() directly.

It probably doesn't - okay I'll use that instead.

David
