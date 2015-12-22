From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Tue, 22 Dec 2015 14:02:44 -0800
Message-ID: <1592CC7D-B2F2-4E8B-BB90-4A20682B1FEE@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <4845518.edhUzAktsU@wuerfel> <CA+iXiiN8xFaiz6DwyLfWRFZ81pJZf=Fv1E60VZC-iSNPswaGEQ@mail.gmail.com> <201512222256.20580.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201512222256.20580.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Santosh Shukla <santosh.shukla@linaro.org>
Cc: josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On December 22, 2015 1:56:20 PM PST, Arnd Bergmann <arnd@arndb.de> wrote:
>On Tuesday 22 December 2015, Santosh Shukla wrote:
>> }
>> 
>> So I care for /dev/ioport types interface who could do more than byte
>> data copy to/from user-space. I tested this patch with little
>> modification and could able to run pmd driver for arm/arm64 case.
>> 
>> Like to know how to address pci_io region mapping problem for
>> arm/arm64, in-case /dev/ioports approach is not acceptable or else I
>> can spent time on restructuring the patch?
>> 
>
>For the use case you describe, can't you use the vfio framework to
>access the PCI BARs?
>
>After all, you are talking about regular PCI devices, not access to
>random unknown I/O port numbers.
>
>	Arnd

On that subject, shouldn't we have common infrastructure to deal with memory mapped I/O ports in the kernel?  Or do we have that now?  I obviously don't pay too much attention...
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
