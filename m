From: chris hyser <chris.hyser@oracle.com>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Thu, 9 Nov 2017 13:27:47 -0500
Message-ID: <6b2cbf61-f1d7-76c7-1361-7d807d05829f@oracle.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
 <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <1510020963.736.42.camel@gmail.com>
 <20171107032310.GA6429@mail.hallyn.com>
 <da764cbf-7522-06a0-6c21-adfa3eaac9c2@oracle.com>
 <20171109180536.GA27994@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171109180536.GA27994@mail.hallyn.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Micay <danielmicay@gmail.com>, =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+?= =?UTF-8?B?4KSwKQ==?= <maheshb@google.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On 11/09/2017 01:05 PM, Serge E. Hallyn wrote:
> Would the existing capability bounding set not suffice for that?
> 
> The 'permanent' bounding set turns out to not be a good fit for
> the problem being discussed in this thread, but please feel free
> to start a new thread if you want to discuss your use case.

Sure. I will formulate something for a new thread. What seems to be 
asked for here is a way to globally patch the capability sets of a 
entire process subtree.

-chrish
