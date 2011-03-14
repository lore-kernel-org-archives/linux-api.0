From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sun, 13 Mar 2011 21:45:09 -0400
Message-ID: <4D7D7325.2040708@garzik.org>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <4D7AC0FE.8070806@gmail.com> <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl> <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl> <4D7BBC03.3020404@garzik.org> <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On 03/13/2011 09:31 PM, Indan Zupancic wrote:
> The new syscall works on only one fd too. The behaviour of the proposed
> syncfs and an extended sync_file_range is exactly the same.

No, it's not.  You should read the patch before commenting.

	Jeff
