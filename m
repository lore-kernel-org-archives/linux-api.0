From: Jessica Yu <jeyu@redhat.com>
Subject: Re: module: s390: keep mod_arch_specific for livepatch modules
Date: Wed, 3 Feb 2016 20:37:52 -0500
Message-ID: <20160204013751.GB22860@packer-debian-8-amd64.digitalocean.com>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-4-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-4-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [03/02/16 20:11 -0500]:
>Livepatch needs to utilize the symbol information contained in the
>mod_arch_specific struct in order to be able to call the s390
>apply_relocate_add() function to apply relocations. Keep a reference to
>syminfo if the module is a livepatch module. Remove the redundant vfree()
>in module_finalize() since module_arch_freeing_init() (which also frees
>those structures) is called in do_init_module(). If the module isn't a
>livepatch module, we free the structures in module_arch_freeing_init() as
>usual.
>
>Signed-off-by: Jessica Yu <jeyu@redhat.com>
>---
> arch/s390/kernel/module.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)

I must note that I have verified that the patchset boots on s390 and
that the sample livepatch module still works ...so that's good, but
not saying much since what we really want is to test the relocation
code. The kpatch build scripts however currently only support x86, so
the next step is for me to port the kpatch scripts to s390 before I
can really test this patchset. This in itself might take a while, so
in the meantime I'd like to just collect another round of comments and
feedback for v4.

Jessica
