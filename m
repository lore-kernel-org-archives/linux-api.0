From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Sat, 26 Jul 2014 12:48:48 -0700
Message-ID: <87egx7dhpb.fsf@x220.int.ebiederm.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140725223550.3153f436@alan.etchedpixels.co.uk>
	<CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Jul 2014 14:41:47 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Jul 25, 2014 at 2:35 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 25 Jul 2014 11:30:48 -0700
>> Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>> [new thread because this sort of combines two threads]
>>>
>>> There is recent interest in having a way to turn generally-available
>>> kernel features off.  Maybe we should add a good one so we can stop
>>> bikeshedding and avoid proliferating dumb interfaces.
>>
>> We sort of have one. It's called capable(). Just needs extending to cover
>> anything else you care about, and probably all the numeric constants
>> replacing with textual names.

The big difference is capable only subdivides roots powers (aka things
most applications should not have).  When we start talking about things
that things that are safe for most applications capable is probably not
the right tool for the job.

A much closer match is the personality system call.  Look at setarch
to see how it is used.  My biggest concern with personality is there
are only 32bits to play with.  Still I expect what you want may be a
sandbox personality, that disables everything that could possibly be
a problem (including access to the personality syscall).

Eric
