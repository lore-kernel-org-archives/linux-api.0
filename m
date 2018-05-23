From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Wed, 23 May 2018 16:46:03 +0800
Message-ID: <20180523084603.GD7474@linux-l9pv.suse>
References: <20180413202234.GA4484@amd>
 <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
 <27926.1524148733@warthog.procyon.org.uk>
 <20180426072646.GA31822@amd>
 <nycvar.YFH.7.76.1804261018030.28147@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1804261018030.28147@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi experts, 

Sorry for I missed this discussion...

On Thu, Apr 26, 2018 at 10:20:29AM +0200, Jiri Kosina wrote:
> On Thu, 26 Apr 2018, Pavel Machek wrote:
> 
> > That's not how the crypto needs to work. Talk to Jiri Kosina, ok?
> 
> Yeah, Joey Lee (adding to CC) implemented it here:
> 
> 	https://lkml.org/lkml/2015/8/11/47
> 
> I think there have been more respins, Joey definitely knows more details 
> and status quo.
> 
> The design is specifically tailored for secure-boot environments though.
>

I am working on the next version of hibernation encryption and authentication:
    https://github.com/joeyli/linux-s4sign/wiki 

My plan is:

- Hibernation encryption:
  There is a draft patch to encrypt image by ctr(aes). This patch works
  with the first version of hibernation verification:
  https://github.com/joeyli/linux-s4sign/commit/6a9a0113bb221c036ebd0f6321b7191283fe4929

- Adapt hibernation to key retention service:
    - Using the encrypted key to derive encrypt key and auth key to
      encrypt and hmac snapshot image. Put the encrypted key in the image
      header of snapshot.
    - The encrypted key will be encrypted by KMK (kernel master key). Either
      trusted key(sealed by TPM) or EFI key (explain in later) can be the KMK.
      If there have appropriate UI support in initrd, user key can also be
      the KMK.
    - Similar with the enrolling EVM key, but more earler:
      The systemd and dracut must be changed for enrolling kernel master key
      before the swap partition be mounted.

- EFI key:
    - A new master key type to key retention service.
	- It can be a new option beyond trusted key(TPM) and user key.
    - EFI stub generates a random key and stores in EFI boot service
      variable:
	- This random key in boot variable can be called ERK (EFI Root Key)
	- The ERK is secure when secure boot enabled.
	    - User must aware and enable secure boot by themself if they want.
	- ERK can be a secret to encrypt a random number for generate a EFI key
	   - The EFI key can be used by hibernation encryption/authentication.
	   - The EFI key can be a master key to generate a encrypted key for EVM.
    - Rescue mechanism for ERK:
	- The ERK may be regenerated after the old ERK be erased by firmware update
	  or firmware recovery.
	- Current idea is using the public key in first/second trusted keyring
	  to encrypt the ERK for backup. User can enroll the EFI key with old ERK to
	  request kernel to re-encrypt the EFI key with new ERK.


Thanks a lot!
Joey Lee
