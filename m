From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Wed, 30 Jul 2014 15:37:12 +0100
Message-ID: <20140730153713.736881f0@alan.etchedpixels.co.uk>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
	<87oawa740c.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <87oawa740c.fsf@x220.int.ebiederm.org>
Sender: linux-crypto-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, linux-crypto@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

> Andy you seem to be arguing here for two system calls.
> get_urandom() and get_random().
> 
> Where get_urandom only blocks if there is not enough starting entropy,
> and get_random(GRND_RANDOM) blocks if there is currently not enough
> entropy.
> 
> That would allow -ENOSYS to be the right return value and it would
> simply things for everyone.

So you replace the "no file handle" special case with the "unsupported or
disabled syscall" special case, which is even harder to test.

Interfaces have failure modes. People who can't deal with that shouldn't
be writing code that does anything important in languages which don't
handle it for them.

Alan
