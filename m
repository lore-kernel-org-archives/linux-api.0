From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 21 Dec 2015 00:57:42 -0500
Message-ID: <20151221055742.GB22850@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151208183844.GC14846@treble.redhat.com>
 <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
 <20151216054048.GA28258@packer-debian-8-amd64.digitalocean.com>
 <20151217154500.GG3729@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151217154500.GG3729@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Petr Mladek [17/12/15 16:45 +0100]:
>On Wed 2015-12-16 00:40:48, Jessica Yu wrote:
>> Turns out the string parsing stuff, even with the help of lib/string.c, doesn't
>> look very pretty. As I'm working on v3, I'm starting to think having
>> klp_write_object_relocations() loop simply through all the elf sections might
>> not be a good idea. Let me explain.
>>
>> I don't like the amount of string manipulation code that would potentially come
>> with this change. Even with a string as simple as ".klp.rela.objname", we'll
>> end up with a bunch of kstrdup's/kmalloc's and kfree's (unless we modify and
>> chop the section name string in place, which I don't think we should do) that
>> are going to be required at every iteration of the loop, all just to be able to
>> call strcmp() and see if we're dealing with a klp rela section that belongs to
>> the object in question. This also leads to more complicated error handling.
>
>I do not think that we need to allocate and free buffers every time
>we compare a substring.
>
>One possibility is to find the position of the substring using
>strchr(). Then you could compare it using strncmp() and pass there
>the pointer where the substring begins.

Hm, yes you're right. Specifically, it looks like strcspn() would also
be useful for this situation (i.e. calculate the length of a substring
that does not contain certain characters); combined with strncmp(),
this should make the string code much simpler, and no more buffer
allocating/freeing. :-)

Jessica
