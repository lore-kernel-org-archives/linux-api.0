From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Wed, 30 Jul 2014 19:37:47 -0700
Message-ID: <87wqaudzic.fsf@x220.int.ebiederm.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
	<87oawa740c.fsf@x220.int.ebiederm.org>
	<20140730153713.736881f0@alan.etchedpixels.co.uk>
	<87r412g04a.fsf@x220.int.ebiederm.org>
	<20140730222903.4c83a652@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140730222903.4c83a652@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 30 Jul 2014 22:29:03 +0100")
Sender: linux-security-module-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, linux-crypto@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

> On Wed, 30 Jul 2014 11:41:41 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:
>> 
>> >> Andy you seem to be arguing here for two system calls.
>> >> get_urandom() and get_random().
>> >> 
>> >> Where get_urandom only blocks if there is not enough starting entropy,
>> >> and get_random(GRND_RANDOM) blocks if there is currently not enough
>> >> entropy.
>> >> 
>> >> That would allow -ENOSYS to be the right return value and it would
>> >> simply things for everyone.
>> >
>> > So you replace the "no file handle" special case with the "unsupported or
>> > disabled syscall" special case, which is even harder to test.
>> >
>> > Interfaces have failure modes. People who can't deal with that shouldn't
>> > be writing code that does anything important in languages which don't
>> > handle it for them.
>> 
>> Perhaps I misread the earlier conversation but it what I have read of
>> this discussion people want to disable some of get_random() modes with
>> seccomp.  Today get_random does not have any failure codes define except
>> -ENOSYS.
>> 
>> get_random(0) succeeding and get_random(GRND_RANDOM) returning -ENOSYS
>> has every chance of causing applications to legitimately assume the
>> get_random system call is not available in any mode.
>
> Or more likely it'll be used like this
>
> 	get_random(foo);		/* always works */
>
>
> Now the existing failure mode is is
>
> 	open(...)
> 	/* forget the check */
> 	read()
> 	/* forget the check */
>
> and triggered by evil local attacks on file handles. The "improved"
> behaviour is unchecked -ENOSYS returns which are likely to occur
> systemically when users run stuff on old kernels, in vm's with it off etc.
>
> So you've swapped the odd evil user attack on a single target for the
> likelyhood of mass generation of flawed keys with no error reporting.
>
> In fact you could do a better job of the whole mess in libc rather than
> the kernel, because in libc you'd write it like this
>
>          if (open(.. ) < 0)
> 		kill(getpid(), 9);
> 	 if (read(...) < expected)
> 		kill(getpid(), 9);
> 	 close(fd);
>
> and 
> a) on an older library you'd get a good failure (unable to execute the
> binary)
> b) on a newer system you'd get "do or die" behaviour and can improve its
> robustness as desired

I have said enough about the silliness of disabling this syscall with
seccomp or related infrastructure.

The aspect I like about get_random() is that it will silence the
requests from people to enable binary sysctl support in the kernel.
Just so they can get random numbers when /dev/random and /dev/urandom
are absent in their chroots.

sysctl(2) is finally legitmately going fading away.

Eric

