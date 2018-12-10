From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 10 Dec 2018 12:39:12 -0500
Message-ID: <f3db1a75-e6f2-06a8-5264-a6807b7b4538@redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110192027.GA29892@kroah.com>
 <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
 <20181112023630.GA20359@kroah.com> <20181112090828.2573987d@lwn.net>
 <b3d765e1-69a0-d4f0-b04a-40c19df8111c@infradead.org>
 <20181210092706.1aa54432@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210092706.1aa54432@lwn.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/10/18 11:27 AM, Jonathan Corbet wrote:
> On Sat, 8 Dec 2018 20:38:56 -0800
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> On 11/12/18 8:08 AM, Jonathan Corbet wrote:
>>> On Sun, 11 Nov 2018 18:36:30 -0800
>>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>>   
>>>> We should have a checklist.  That's a great idea.  Now to find someone
>>>> to write it... :)  
>>>
>>> Do we think the LPC session might have the right people to create such a
>>> thing?  If so, I can try to put together a coherent presentation of the
>>> result.  
>>
>> Hi,
>> Did anything ever happen with this syscall checklist suggestion?
> 
> No, we really didn't have the right people around to do that,
> unfortunately.  

We already have Documentation/process/adding-syscalls.rst.

The documentation there is quite thorough.

It lists things that people commonly forget e.g. email linux-api@vger.kernel.org.

Would it be acceptable to attempt to collate per-libc information
into the adding-syscalls.rst under a new section called:

"Integration with libc"

-- 
Cheers,
Carlos.
