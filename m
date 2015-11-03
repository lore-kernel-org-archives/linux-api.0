From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Tue, 3 Nov 2015 09:03:44 -0600
Message-ID: <20151103150344.GJ27488@treble.redhat.com>
References: <20151102203241.GF27488@treble.redhat.com>
 <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
 <alpine.LNX.2.00.1511031043470.6257@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511031043470.6257@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Chris J Arges <chris.j.arges@canonical.com>, live-patching@vger.kernel.org, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 10:50:05AM +0100, Miroslav Benes wrote:
> On Mon, 2 Nov 2015, Chris J Arges wrote:
> 
> > The following directory structure will allow for cases when the same
> > function name exists in a single object.
> > 	/sys/kernel/livepatch/<patch>/<object>/<function.number>
> 
> There is still a period here and in the documentation :)

and in the subject :-)

-- 
Josh
