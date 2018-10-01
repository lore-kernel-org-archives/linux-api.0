From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC 0/2] ns: introduce binfmt_misc namespace
Date: Mon, 1 Oct 2018 09:13:41 +0200
Message-ID: <d1b6b52b-dd7f-fa27-eafa-7a6a43a03b92@vivier.eu>
References: <20180930234628.25528-1-laurent@vivier.eu>
 <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, Andrey Vagin <avagin@openvz.org>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Le 01/10/2018 à 06:45, Andy Lutomirski a écrit :
> On Sun, Sep 30, 2018 at 4:47 PM Laurent Vivier <laurent@vivier.eu> wrote:
>>
>> This series introduces a new namespace for binfmt_misc.
>>
> 
> This seems conceptually quite reasonable, but I'm wondering if the
> number of namespace types is getting out of hand given the current
> API.  Should we be considering whether we need a new set of namespace
> creation APIs that scale better to larger numbers of namespace types?
> 

Yes, we need something to increase the maximum number of namespace types
because this is the last bit in the clone() flags and the time namespace
has already preempted it.

Thanks,
Laurent
