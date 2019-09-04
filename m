From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 11/11] smack: Implement the watch_key and
 post_notification hooks [untested] [ver #7]
Date: Wed, 4 Sep 2019 07:56:46 -0700
Message-ID: <5be00881-258a-d888-e544-0d14ac496dcf@schaufler-ca.com>
References: <23d61564-026e-b37a-8b16-ce68d5949f6c@schaufler-ca.com>
 <87bf0363-af77-1e5a-961f-72730e39e3a6@schaufler-ca.com>
 <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com>
 <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk>
 <4910.1567525310@warthog.procyon.org.uk>
 <11467.1567534014@warthog.procyon.org.uk>
 <31205.1567598939@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31205.1567598939@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 9/4/2019 5:08 AM, David Howells wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> I rebuilt with keys-next, updated the tests again, and now
>> the suite looks to be running trouble free.
> Can I put you down as an Acked-by or something on this patch?

I haven't done anything to see if the patch is actually useful.
I don't have much (read: anything) in the way of key tests for
Smack, so I can't say if this is what I want long term. But as
it does appear harmless, yes, you can add my Acked-by on this.

>
> Thanks,
> David
