From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH 00/21] pipe: Keyrings, Block and USB notifications
Date: Wed, 16 Oct 2019 09:11:07 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1910160909230.11167@namei.org>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 15 Oct 2019, David Howells wrote:

> 
> Here's a set of patches to add a general notification queue concept and to
> add event sources such as:

On the next iteration, please include the rationale for this per your 
previous posting: https://lkml.org/lkml/2019/9/5/857


-- 
James Morris
<jmorris@namei.org>
