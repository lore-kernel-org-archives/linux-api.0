From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 16:54:41 -0700
Message-ID: <4F9B31C1.3010701@cs.ucla.edu>
References: <20120419163238.61D382C0DF@topped-with-meat.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <19184.1335448455@redhat.com> <20120426182524.E5ADF2C0EC@topped-with-meat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120426182524.E5ADF2C0EC@topped-with-meat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Roland McGrath <roland@hack.frob.com>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On 04/26/2012 11:25 AM, Roland McGrath wrote:
> What I'd really prefer is a name that is less meaninglessly arcane,

Since people are used to the string "stat", and since this is
about getting related attributes, how about using the string "statr"?
Thus "statrat" could be the syscall that acts like fstatat, but gets
related attributes too.

A bonus of this name is that a "stat rat" is slang
for someone who loves looking at statistics, often
sports statistics.  Billy Beane is a stat rat.
Someone who cares about files' statistics is also
a stat rat.

The "r" in "statrat" could stand for "related", or
for "relevant", or for whatever you like.
