From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] leftpad.2: Document new syscall
Date: Sat, 9 Apr 2016 16:12:34 +0200
Message-ID: <57090DD2.2040803@nod.at>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-3-git-send-email-richard@nod.at> <5707F419.6060300@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5707F419.6060300@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Daniel Walter <dwalter@sigma-star.at>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Am 08.04.2016 um 20:10 schrieb Heinrich Schuchardt:
> On 04/01/2016 12:33 AM, Richard Weinberger wrote:
>> From: Daniel Walter <dwalter@sigma-star.at>
>>
>> Signed-off-by: Daniel Walter <dwalter@sigma-star.at>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  man2/leftpad.2 | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>  create mode 100644 man2/leftpad.2
>>
>> diff --git a/man2/leftpad.2 b/man2/leftpad.2
>> new file mode 100644
>> index 0000000..ff5f401
>> --- /dev/null
>> +++ b/man2/leftpad.2
>> @@ -0,0 +1,55 @@
>> +.\" Copyright (c) 2016 sigma-star gmbh
>> +.\" (office@sigma-star.at)
>> +.\"
>> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
>> +.\" This is free documentation; you can redistribute it and/or
>> +.\" modify it under the terms of the GNU General Public License as
>> +.\" published by the Free Software Foundation; either version 2 of
>> +.\" the License, or (at your option) any later version.
>> +.\"
>> +.\" The GNU General Public License's references to "object code"
>> +.\" and "executables" are to be interpreted as the output of any
>> +.\" document formatting or typesetting system, including
>> +.\" intermediate and printed output.
>> +.\"
>> +.\" This manual is distributed in the hope that it will be useful,
>> +.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +.\" GNU General Public License for more details.
>> +.\"
>> +.\" You should have received a copy of the GNU General Public
>> +.\" License along with this manual; if not, see
>> +.\" <http://www.gnu.org/licenses/>.
>> +.\" %%%LICENSE_END
>> +.\"
>> +.TH LEFTPAD 2 2016-04-01 "Linux" "Linux Programmer's Manual"
>> +.SH NAME
>> +leftpad
>> +.SH SYNOPSIS
>> +.nf
>> +.B #include <sys/types.h>
>> +
>> +.BI "int leftpad(char *src, char pad, char *dst, size_t dst_len);
>> +.fi
>> +.SH DESCRIPTION
>> +This function provides left padding for strings.
>> +.LP
>> +The string in
>> +.I src
>> +will be left padded with the chosen padding character
>> +.I pad
>> +and stored in
>> +.I dst
>> + .
>> +.SH RETURN VALUE
>> +On success, returns the number of padding characters added.
>> +.SH ERRORS
>> +.TP
>> +.B EINVAL
>> +The size of the destination buffer
>> +.I dst
>> +is shorter than the source string
>> +.I src
>> + . Or the destination string is longer than 4096 bytes.
> 
> Why should the call be limited to an arbitrary number of 4096 bytes?
> 
> There is no such limit in malloc so why should we need one here?
> 
> NAK

Sorry, the review window for this patch is now closed.
Please resend your comments on April 1st 2017.

Thanks,
//richard
