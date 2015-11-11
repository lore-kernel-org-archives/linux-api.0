From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH 5/5] livepatch: x86: remove unused relocation code
Date: Wed, 11 Nov 2015 16:48:07 +0100
Message-ID: <20151111154807.GR2599@pathway.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-6-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447130755-17383-6-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-09 23:45:55, Jessica Yu wrote:
> Architecture-specific relocation code no longer needed, since symbol
> resolution and relocation work will be offloaded to module loader.
                                 ^^^^
				 has been

I would personally merge this with the 3rd patch. It will be more
clear what code has been replaced there. But it is a matter of taste.

Best Regards,
Petr
