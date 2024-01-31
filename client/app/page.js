"use client";
import React, { useState, useEffect } from "react";
import { db, auth } from "./firebase";
import { useAuthState } from "react-firebase-hooks/auth";
import { useRouter } from "next/navigation";
import { getAuth, onAuthStateChanged, signOut } from "firebase/auth";
import Landing from "./components/Landing";
import Carousel from "./components/Carousel";

export default function Home() {
  const auth = getAuth();
  const [user] = useAuthState(auth);
  const router = useRouter();

  onAuthStateChanged(auth, (user) => {
    if (user) {
      const uid = user.uid;
      console.log(uid);
    } else {
      // router.push("/sign-in");
      router.push("/landing");
      // return <Landing />
    }
  });

  return (
    <div>
      <button
				onClick={() => {
					signOut(auth);
					// sessionStorage.removeItem("user");
				}}
			>
				Log Out
			</button>
			Welcome {user?.email}
      <div className='flex items-center justify-between mr-8'>
        <img src="/logo.png" alt="" className="h-[199px] w-[566px]" />
        <div className="flex gap-2">
        <a href="#" className='text-[#BCA875] text-3xl font-normal'><div className="dropdowns flex justify-between px-2 items-center">
            Price
            <img src="/dropdown.png" alt="" className="" />
          </div></a>
          <a href="#" className='text-[#BCA875] text-3xl font-normal'><div className="dropdowns flex justify-between px-2 items-center">
            Beds & Bath
            <img src="/dropdown.png" alt="" className="" />
          </div></a>
          <a href="#" className='text-[#BCA875] text-3xl font-normal'><div className="dropdowns flex justify-between px-2 items-center">
            Home Type
            <img src="/dropdown.png" alt="" className="" />
          </div></a>
          <a href="#" className='text-[#BCA875] text-3xl font-normal'><div className="dropdowns flex justify-between px-2 items-center">
            More
            <img src="/dropdown.png" alt="" className="" />
          </div></a>
        </div>
      </div>
      <Carousel />
      <div className="grid grid-cols-2 gap-16 px-28 py-10">
        <div className="flex flex-col">
          <img src="/house1.png" alt="" className="h-80" />
          <div className="h-[100px] rounded-b-[20px] bg-[#D9D9D9]">

          </div>
        </div>
        <div className="flex flex-col">
          <img src="/house2.png" alt="" className="h-80" />
          <div className="h-[100px] rounded-b-[20px] bg-[#D9D9D9]">

          </div>
        </div>
        <div className="flex flex-col">
          <img src="/house3.png" alt="" className="h-80" />
          <div className="h-[100px] rounded-b-[20px] bg-[#D9D9D9]">

          </div>
        </div>
        <div className="flex flex-col">
          <img src="/house4.png" alt="" className="h-80" />
          <div className="h-[100px] rounded-b-[20px] bg-[#D9D9D9]">

          </div>
        </div>
      </div>
      <div className='z-10 fixed bottom-0 footer-bg w-full flex items-center gap-20'>
        <div className='flex items-center p-4 gap-12'>
          <img src="account.png" alt="" className="w-20" />
          <div className='landingsearchbar p-2 w-[340px] h-[65px] flex items-center'>
            <img src='/Search.png' alt="" className="" />
          </div>
        </div>
        <div className='flex gap-10 items-center'>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>Rent</a>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>Buy</a>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>Sell</a>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>Services</a>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>About Us</a>
          <a href="#" className='text-[#BCA875] text-4xl font-normal'>Help</a>
        </div>
      </div>
    </div>
  );
}
