From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Wed, 30 Jul 2014 11:41:41 -0700
Message-ID: <87r412g04a.fsf@x220.int.ebiederm.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
	<87oawa740c.fsf@x220.int.ebiederm.org>
	<20140730153713.736881f0@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20140730153713.736881f0@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 30 Jul 2014 15:37:12 +0100")
Sender: linux-crypto-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, linux-crypto@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

>> Andy you seem to be arguing here for two system calls.
>> get_urandom() and get_random().
>> 
>> Where get_urandom only blocks if there is not enough starting entropy,
>> and get_random(GRND_RANDOM) blocks if there is currently not enough
>> entropy.
>> 
>> That would allow -ENOSYS to be the right return value and it would
>> simply things for everyone.
>
> So you replace the "no file handle" special case with the "unsupported or
> disabled syscall" special case, which is even harder to test.
>
> Interfaces have failure modes. People who can't deal with that shouldn't
> be writing code that does anything important in languages which don't
> handle it for them.

Perhaps I misread the earlier conversation but it what I have read of
this discussion people want to disable some of get_random() modes with
seccomp.  Today get_random does not have any failure codes define except
-ENOSYS.

get_random(0) succeeding and get_random(GRND_RANDOM) returning -ENOSYS
has every chance of causing applications to legitimately assume the
get_random system call is not available in any mode.

So the code either needs a defined error code for bad flags (-EINVAL) or
we need to split the syscall in two.  Now that I think about it having
the seccomp filter return -EINVAL if it doesn't like the parameter is
better that splitting a syscall.  Presumably that is what
get_random(UNSUPPORTED_FLAG) returns.

Eric
