From: Laura Abbott <labbott@redhat.com>
Subject: Re: Kernel lockdown patch & IPAddressAllow/IPAddressDeny systemd
 feature with Secure Boot
Date: Thu, 16 Aug 2018 06:36:26 -0700
Message-ID: <17c09f82-a32d-fc3b-042b-c44c366f873c@redhat.com>
References: <20180807212531.25161.63476@mailman01.phx2.fedoraproject.org>
 <CALeDE9ORLoyiUcf8Bmwr2rPyo7-3d8Fo54WuPGWtv4ByE_JG=Q@mail.gmail.com>
 <CAObL_7GOOQ01NPf4y1MqRJh4S=CYV8NPmEGTbkrTcjrfUKc5LA@mail.gmail.com>
 <20180816021037.6yxi5rqolhqxipza@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180816021037.6yxi5rqolhqxipza@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrew Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, ast@kernel.org, Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kernel Fedora <kernel@lists.fedoraproject.org>, daniel@iogearbox.net
List-Id: linux-api@vger.kernel.org

On 08/15/2018 07:10 PM, Alexei Starovoitov wrote:
> On Tue, Aug 14, 2018 at 07:14:00AM -0700, Andrew Lutomirski wrote:
>> [Removed Fedora devel list because it's subscriber-only]
>>
>>> On Aug 8, 2018, at 12:29 AM, Peter Robinson <pbrobinson@gmail.com> wrote:
>>>
>>> Probably a good idea to cc: this to the kernel list :-)
>>>
>>> I suspect it's intentional but with the planned changes for iptables
>>> etc to be backed by bpf in the upstream kernel sometime in the future
>>> it's likely going to need to be reviewed.
>>>
>>
>> I thought this got covered in review. I think this part of lockdown
>> needs to get reverted or fixed ASAP.
> 
> I don't see lockdown in Linus's tree. Is this fedora only issue?
> 

The entire lockdown/secure boot series is out of tree at the moment.
We're working to get it included.  If you search LWN, you
can find some articles explaining the long saga of the patch series.

>> (I definitely brought up multiple issues with the bpf lockdown stuff.
>> It's clearly extremely broken right now in the "new kernel breaks
>> *current* Linux distro" sense.)
> 
> +1
> 

Yes, we need to review what exactly is in Fedora. It's the merge
window so this is a good time to do that anyway. We're still
playing catch up after Flock in Dresden last week. Can you file
a bugzilla for tracking so we don't forget?

Thanks,
Laura
