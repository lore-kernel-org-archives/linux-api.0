From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v6 1/1] ns: add binfmt_misc to the user namespace
Date: Wed, 24 Oct 2018 18:15:55 +0100
Message-ID: <0fb09ce6-e006-31a2-1f32-f3f6eda44504@vivier.eu>
References: <20181010161430.11633-1-laurent@vivier.eu>
 <20181010161430.11633-2-laurent@vivier.eu> <20181016162245.GA7697@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016162245.GA7697@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>, containers@lists.linux-foundation.org, Dmitry Safonov <dima@arista.com>
List-Id: linux-api@vger.kernel.org

On 16/10/2018 17:22, Andrei Vagin wrote:
> On Wed, Oct 10, 2018 at 06:14:30PM +0200, Laurent Vivier wrote:
>> This patch allows to have a different binfmt_misc configuration
>> for each new user namespace. By default, the binfmt_misc configuration
>> is the one of the previous level, but if the binfmt_misc filesystem is
>> mounted in the new namespace a new empty binfmt instance is created and
>> used in this namespace.
>>
>> For instance, using "unshare" we can start a chroot of another
>> architecture and configure the binfmt_misc interpreter without being root
>> to run the binaries in this chroot.
>>
>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> 
> Acked-by: Andrei Vagin <avagin@gmail.com>
> 
> Thanks,
> Andrei
> 

I don't konw who is the maintainer for this part, but is there any
chance to have this merged in 4.20?

Thanks,
Laurent
