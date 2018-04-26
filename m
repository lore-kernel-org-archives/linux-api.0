From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Thu, 26 Apr 2018 09:34:28 +0200
Message-ID: <4403604.jesDZjvsch@aspire.rjw.lan>
References: <20180413202234.GA4484@amd> <27926.1524148733@warthog.procyon.org.uk> <20180426072646.GA31822@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426072646.GA31822@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: David Howells <dhowells@redhat.com>, jikos@suse.cz, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thursday, April 26, 2018 9:26:46 AM CEST Pavel Machek wrote:
> On Thu 2018-04-19 15:38:53, David Howells wrote:
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > There is currently no way to verify the resume image when returning
> > > > from hibernate.  This might compromise the signed modules trust model,
> > > > so until we can work with signed hibernate images we disable it when the
> > > > kernel is locked down.
> > > 
> > > I'd rather see hibernation fixed than disabled like this.
> > 
> > The problem is that you have to store the hibernated kernel image encrypted,
> > but you can't store the decryption key on disk unencrypted or you've just
> > wasted the effort.
> 
> That's not how the crypto needs to work. Talk to Jiri Kosina, ok?
> 
> Firmware gives you a key, you keep it secret, use it to sign the
> hibernation image on suspend, and verify the signature on resume. Or
> something like that.

A simplified approach might be to encrypt the image during hibernation
using a user-provided passphrase and then ask for that passphrase during
resume to decrypt the image.

The attacker would then need to know the passphrase to substitute their
own image for the original one successfully.
