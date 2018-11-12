From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 21:03:50 -0500
Message-ID: <94ee3c86-781f-e865-8b7a-aa6ebb9a2609@redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110192027.GA29892@kroah.com>
 <6a415f31-2bce-72fa-2ff0-5cbbd572347b@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6a415f31-2bce-72fa-2ff0-5cbbd572347b@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Greg KH <gregkh@linuxfoundation.org>, Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Adhemerval Zanella <adhemerval.zanella@linaro.org>
List-Id: linux-api@vger.kernel.org

On 11/10/18 2:58 PM, Vlastimil Babka wrote:
> On 11/10/18 8:20 PM, Greg KH wrote:
>> On Sat, Nov 10, 2018 at 10:52:06AM -0800, Daniel Colascione wrote:
>>> Now that glibc is basically not adding any new system call wrappers,
>>
>> Why are they not doing that anymore?
> 
> FYI just noticed there's a topic relevant to this in LPC Toolchain MC:
> 
> https://linuxplumbersconf.org/event/2/contributions/149/

Yes, and Adhemerval put it there on purpose to continue the discussion
between glibc developers and kernel developers. Florian Weimer and I have
both provided input to that talk, so if something comes out of the talk
and you want to talk more, please just reach out.

I hope that kernel developers interested in this topic will attend
and discuss the various ways forward on certain interesting topics :-)

-- 
Cheers,
Carlos.
