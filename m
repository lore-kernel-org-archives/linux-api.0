From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 5/5] livepatch: x86: remove unused relocation code
Date: Thu, 12 Nov 2015 12:01:02 -0600
Message-ID: <20151112180102.GI4038@treble.hsd1.ky.comcast.net>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-6-git-send-email-jeyu@redhat.com>
 <20151111154807.GR2599@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151111154807.GR2599@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 11, 2015 at 04:48:07PM +0100, Petr Mladek wrote:
> On Mon 2015-11-09 23:45:55, Jessica Yu wrote:
> > Architecture-specific relocation code no longer needed, since symbol
> > resolution and relocation work will be offloaded to module loader.
>                                  ^^^^
> 				 has been
> 
> I would personally merge this with the 3rd patch. It will be more
> clear what code has been replaced there. But it is a matter of taste.

Ditto.

-- 
Josh
