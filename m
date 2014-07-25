From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Fri, 25 Jul 2014 14:41:47 -0700
Message-ID: <CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
 <20140725223550.3153f436@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20140725223550.3153f436@alan.etchedpixels.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 2:35 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Fri, 25 Jul 2014 11:30:48 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> [new thread because this sort of combines two threads]
>>
>> There is recent interest in having a way to turn generally-available
>> kernel features off.  Maybe we should add a good one so we can stop
>> bikeshedding and avoid proliferating dumb interfaces.
>
> We sort of have one. It's called capable(). Just needs extending to cover
> anything else you care about, and probably all the numeric constants
> replacing with textual names.
>

Except that it's all backwards: these are things that default to *on*,
and people might want them to turn off.  capable() is totally fscked
if you want otherwise unprivileged users to carry capabilities around,
and fixing it seems to run into endless claims that the "capability"
system is carefully designed, flawless, perfect, ideal, amazing, and
shouldn't be changed, despite the fact that it's empirically damn near
useless.

Also, capabilities do the wrong thing wrt namespaces.  The things I'm
talking about aren't namespaced.  They're either on or off.

--Andy
